import 'package:insurance_claim_agent/services/dataset_service.dart';
import 'package:insurance_claim_agent/services/gemini_service.dart';

class RAGService {
  final GeminiService _geminiService = GeminiService();

  // Generate a response using RAG
  Future<String> generateResponse(
    String userQuery, {
    String? documentContent,
  }) async {
    try {
      // Step 1: Retrieve relevant data from the dataset
      final relevantRecords = await DatasetService.searchDataset(userQuery);

      // Step 2: Format the context for the LLM
      final context = _formatContext(relevantRecords);

      // Step 3: Generate response using Gemini with the context
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

  // Format the context for the LLM
  String _formatContext(List<Map<String, dynamic>> records) {
    if (records.isEmpty) {
      return "No relevant data found in the insurance dataset.";
    }

    final buffer = StringBuffer();
    buffer.writeln("Relevant insurance policy data from the dataset:");
    buffer.writeln();

    for (int i = 0; i < records.length; i++) {
      final record = records[i];
      buffer.writeln("Record ${i + 1}:");
      record.forEach((key, value) {
        buffer.writeln("  $key: $value");
      });
      buffer.writeln();
    }

    return buffer.toString();
  }
}
