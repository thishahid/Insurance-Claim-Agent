import 'package:insurance_claim_agent/services/dataset_service.dart';
import 'package:insurance_claim_agent/services/gemini_service.dart';
import 'package:insurance_claim_agent/config/api_config.dart';

class RAGService {
  final GeminiService _geminiService = GeminiService();
  bool _isInitializing = false;
  bool _isInitialized = false;

  // Generate a response using RAG
  Future<String> generateResponse(
    String userQuery, {
    String? documentContent,
  }) async {
    try {
      // Ensure the Gemini service is initialized
      await _ensureInitialized();

      // Step 1: Extract key identifiers from the query
      final extractedInfo = _extractKeyInfo(userQuery);

      // Step 2: Retrieve relevant data from the dataset based on extracted info
      List<Map<String, dynamic>> relevantRecords = [];
      String queryExplanation = "";

      // Check for policy_id
      if (extractedInfo['policy_id'] != null) {
        final record = await DatasetService.getRecordByPolicyId(
          extractedInfo['policy_id']!,
        );
        if (record != null) {
          relevantRecords.add(record);
          queryExplanation =
              "Found policy with ID: ${extractedInfo['policy_id']}";
        }
      }

      // Check for claim status
      if (extractedInfo['claim_status'] != null) {
        final records = await DatasetService.getRecordsByClaimStatus(
          extractedInfo['claim_status']!,
        );
        relevantRecords.addAll(records);
        if (queryExplanation.isEmpty) {
          queryExplanation =
              "Found policies with claim status: ${extractedInfo['claim_status']}";
        }
      }

      // Check for vehicle age range
      if (extractedInfo['vehicle_age_min'] != null &&
          extractedInfo['vehicle_age_max'] != null) {
        final records = await DatasetService.getRecordsByVehicleAgeRange(
          extractedInfo['vehicle_age_min']!,
          extractedInfo['vehicle_age_max']!,
        );
        relevantRecords.addAll(records);
        if (queryExplanation.isEmpty) {
          queryExplanation =
              "Found policies with vehicle age between ${extractedInfo['vehicle_age_min']} and ${extractedInfo['vehicle_age_max']}";
        }
      }

      // If no specific queries, do a general search
      if (relevantRecords.isEmpty) {
        relevantRecords = await DatasetService.searchDataset(userQuery);
        queryExplanation = "General search results for: $userQuery";
      }

      // Step 3: Format the context for the LLM with clear instructions
      final context = _formatContext(
        relevantRecords,
        queryExplanation,
        userQuery,
      );

      // Step 4: Generate response using Gemini with the context
      final response = await _geminiService.generateResponse(
        userQuery,
        documentContent: documentContent,
        datasetContext: context,
      );

      return response;
    } catch (e) {
      return "Error generating response: ${e.toString()}";
    }
  }

  // Extract key information from the user query
  Map<String, dynamic> _extractKeyInfo(String query) {
    final Map<String, dynamic> result = {};

    // Extract policy_id (format: POL followed by 6 digits)
    final policyIdRegex = RegExp(r'POL\d{6}');
    final policyIdMatch = policyIdRegex.firstMatch(query);
    if (policyIdMatch != null) {
      result['policy_id'] = policyIdMatch.group(0);
    }

    // Extract claim status (0 or 1)
    final claimStatusRegex = RegExp(r'claim status\s*[=:]\s*(0|1)');
    final claimStatusMatch = claimStatusRegex.firstMatch(query.toLowerCase());
    if (claimStatusMatch != null) {
      result['claim_status'] = claimStatusMatch.group(1);
    }

    // Extract vehicle age range
    final vehicleAgeRangeRegex = RegExp(
      r'vehicle age\s*(?:between|from)\s*(\d+)\s*(?:to|and)\s*(\d+)',
      caseSensitive: false,
    );
    final vehicleAgeMatch = vehicleAgeRangeRegex.firstMatch(query);
    if (vehicleAgeMatch != null) {
      result['vehicle_age_min'] = int.tryParse(vehicleAgeMatch.group(1)!);
      result['vehicle_age_max'] = int.tryParse(vehicleAgeMatch.group(2)!);
    }

    return result;
  }

  // Ensure the Gemini service is initialized
  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;
    if (_isInitializing) {
      // Wait until initialization is complete
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return;
    }

    _isInitializing = true;
    try {
      await _geminiService.initialize();
      _isInitialized = true;
    } catch (e) {
      // Log the error but don't rethrow to avoid breaking the flow
      print('Failed to initialize Gemini service: $e');
    } finally {
      _isInitializing = false;
    }
  }

  // Format the context for the LLM with clear instructions
  String _formatContext(
    List<Map<String, dynamic>> records,
    String queryExplanation,
    String userQuery,
  ) {
    final buffer = StringBuffer();

    buffer.writeln("INSTRUCTIONS FOR ANSWERING:");
    buffer.writeln(
      "1. Use the dataset information below to answer the user's question.",
    );
    buffer.writeln(
      "2. If the dataset contains the specific information requested (e.g., policy details), provide that information directly.",
    );
    buffer.writeln(
      "3. If the dataset doesn't contain the specific information, use your general knowledge but clearly state that the information wasn't found in the dataset.",
    );
    buffer.writeln(
      "4. Format your response in a clear, structured way that highlights the key information.",
    );
    buffer.writeln();

    buffer.writeln("USER QUERY: $userQuery");
    buffer.writeln();
    buffer.writeln("QUERY ANALYSIS: $queryExplanation");
    buffer.writeln();

    if (records.isEmpty) {
      buffer.writeln(
        "DATASET INFORMATION: No relevant records found in the dataset.",
      );
    } else {
      buffer.writeln(
        "DATASET INFORMATION (${records.length} relevant records found):",
      );
      buffer.writeln();

      for (int i = 0; i < records.length; i++) {
        final record = records[i];
        buffer.writeln("Record ${i + 1}:");
        record.forEach((key, value) {
          buffer.writeln("  $key: $value");
        });
        buffer.writeln();
      }
    }

    return buffer.toString();
  }
}
