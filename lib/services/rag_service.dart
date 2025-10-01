import 'package:insurance_claim_agent/services/dataset_service.dart';
import 'package:insurance_claim_agent/services/embedding_service.dart';
import 'package:insurance_claim_agent/services/gemini_service.dart';
import 'package:insurance_claim_agent/config/api_config.dart';

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

      // Step 2: Generate embeddings for semantic search (if API key is available)
      List<Map<String, dynamic>> semanticResults = [];
      final apiKey = await ApiConfig.getApiKey();

      if (apiKey != null && apiKey.isNotEmpty) {
        try {
          // Generate embedding for the user query
          final queryEmbedding = await EmbeddingService.generateEmbedding(
            userQuery,
            apiKey,
          );

          // For each record, generate embedding and calculate similarity
          for (final record in relevantRecords) {
            // Convert record to text
            final recordText = _recordToText(record);
            final recordEmbedding = await EmbeddingService.generateEmbedding(
              recordText,
              apiKey,
            );
            final similarity = EmbeddingService.cosineSimilarity(
              queryEmbedding,
              recordEmbedding,
            );

            // Add similarity score to record
            final recordWithScore = Map<String, dynamic>.from(record);
            recordWithScore['similarity'] = similarity;
            semanticResults.add(recordWithScore);
          }

          // Sort by similarity and take top 3
          semanticResults.sort(
            (a, b) => (b['similarity'] as double).compareTo(
              a['similarity'] as double,
            ),
          );
          semanticResults = semanticResults.take(3).toList();
        } catch (e) {
          // If embedding fails, fall back to keyword search
          semanticResults = relevantRecords.take(3).toList();
        }
      } else {
        // No API key, use keyword search results
        semanticResults = relevantRecords.take(3).toList();
      }

      // Step 3: Format the context for the LLM
      final context = _formatContext(semanticResults);

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

  // Convert a record to text for embedding
  String _recordToText(Map<String, dynamic> record) {
    final buffer = StringBuffer();
    record.forEach((key, value) {
      buffer.writeln('$key: $value');
    });
    return buffer.toString();
  }

  // Format the context for the LLM
  String _formatContext(List<Map<String, dynamic>> records) {
    if (records.isEmpty) {
      return "No relevant data found in the dataset.";
    }

    final buffer = StringBuffer();
    buffer.writeln("Relevant insurance policy data:");
    buffer.writeln();

    for (int i = 0; i < records.length; i++) {
      final record = records[i];
      buffer.writeln("Record ${i + 1}:");
      record.forEach((key, value) {
        if (key != 'similarity') {
          // Skip the similarity score
          buffer.writeln("  $key: $value");
        }
      });

      // Add similarity score if available
      if (record.containsKey('similarity')) {
        buffer.writeln("  Relevance score: ${record['similarity']}%");
      }

      buffer.writeln();
    }

    return buffer.toString();
  }
}
