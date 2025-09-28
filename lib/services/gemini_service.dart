import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:insurance_claim_agent/config/api_config.dart';

class GeminiService {
  late GenerativeModel _model;
  final List<Content> _history = [];

  Future<void> initialize() async {
    final apiKey = await ApiConfig.getApiKey();
    if (apiKey == null) {
      throw Exception('API key not found');
    }
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      ],
    );
  }

  Future<String> generateResponse(
    String prompt, {
    String? attachmentContent,
  }) async {
    try {
      // Combine prompt with attachment content if available
      final fullPrompt = attachmentContent != null
          ? "$prompt\n\nAttachment content:\n$attachmentContent"
          : prompt;

      // Add user message to history
      _history.add(Content.text(fullPrompt));

      // Generate response
      final response = await _model.generateContent(_history);
      String responseText =
          response.text ?? "I'm sorry, I couldn't generate a response.";

      // Format the response to make it more visually appealing
      responseText = _formatResponse(responseText);

      // Add bot response to history
      _history.add(Content.text(responseText));

      return responseText;
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  String _formatResponse(String text) {
    // Fix for bold text formatting
    text = text.replaceAllMapped(
      RegExp(r'\*\*(.*?)\*\*'),
      (match) => '**${match.group(1)}**',
    );

    // Fix for italic text formatting
    text = text.replaceAllMapped(
      RegExp(r'\*(.*?)\*'),
      (match) => '*${match.group(1)}*',
    );

    // Convert numbered lists to markdown format
    text = text.replaceAllMapped(
      RegExp(r'^(\d+)\.\s+(.*?)$', multiLine: true),
      (match) {
        return '${match.group(1)}. ${match.group(2)}';
      },
    );

    // Convert bullet points to markdown format
    text = text.replaceAllMapped(RegExp(r'^[•·-]\s+(.*?)$', multiLine: true), (
      match,
    ) {
      return '- ${match.group(1)}';
    });

    // Ensure proper line breaks
    text = text.replaceAll(
      RegExp(r'\n{3,}'),
      '\n\n',
    ); // Remove excessive line breaks

    return text;
  }

  void clearHistory() {
    _history.clear();
  }
}
