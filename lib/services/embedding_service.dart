import 'dart:convert';
import 'package:http/http.dart' as http;

class EmbeddingService {
  static const String _baseUrl = 'https://api.openai.com/v1/embeddings';
  static const String _model = 'text-embedding-ada-002';

  // Generate embedding for a text
  static Future<List<double>> generateEmbedding(
    String text,
    String apiKey,
  ) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({'input': text, 'model': _model}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final embedding = data['data'][0]['embedding'];
      return List<double>.from(embedding);
    } else {
      throw Exception('Failed to generate embedding: ${response.body}');
    }
  }

  // Calculate cosine similarity between two embeddings
  static double cosineSimilarity(List<double> vecA, List<double> vecB) {
    if (vecA.length != vecB.length) {
      throw Exception('Vectors must be of the same length');
    }

    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < vecA.length; i++) {
      dotProduct += vecA[i] * vecB[i];
      normA += vecA[i] * vecA[i];
      normB += vecB[i] * vecB[i];
    }

    if (normA == 0 || normB == 0) {
      return 0.0;
    }

    return dotProduct / (normA * normB);
  }
}
