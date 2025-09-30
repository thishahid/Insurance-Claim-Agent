// services/gemini_service.dart
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:insurance_claim_agent/config/api_config.dart';
import 'package:insurance_claim_agent/services/document_service.dart';

class GeminiService {
  late GenerativeModel _model;
  final List<Content> _history = [];

  // Base system prompt that defines the AI's role and constraints
  final String _systemPrompt = """
You are an Insurance Claim Assistant, specialized in providing information about insurance claims, policies, and related procedures.

Your role is strictly limited to:
- Answering questions about insurance claims
- Explaining insurance policies and coverage
- Guiding through claim procedures
- Providing information about required documents
- Explaining insurance terminology
- Assisting with claim status inquiries
- Answering questions based on uploaded documents related to insurance

You must:
1. Only respond to insurance-related queries
2. Politely decline to answer questions outside the insurance domain
3. If asked about your capabilities, explain that you can help with insurance-related queries
4. Never provide medical, legal, or financial advice beyond insurance matters
5. If asked about non-insurance topics, respond with: "I'm designed specifically to assist with insurance-related queries. I can help with questions about claims, policies, and insurance procedures. Is there something insurance-related I can help you with?"

Always maintain a professional, helpful tone focused on insurance matters.
""";

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
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
      ],
    );
  }

  Future<String> generateResponse(
    String prompt, {
    String? documentContent,
  }) async {
    try {
      // Build the full prompt with system instructions and document content if available
      String fullPrompt;

      if (documentContent != null) {
        // Truncate document content if it's too long
        final truncatedContent = DocumentService.truncateText(documentContent);

        fullPrompt =
            """
 $_systemPrompt

You have access to the following document content related to insurance. 
Please answer the user's question based primarily on this document content. 
If the information is not in the document, use your insurance knowledge to respond.

Document content:
 $truncatedContent

User's question: $prompt
""";
      } else {
        fullPrompt =
            """
 $_systemPrompt

User's question: $prompt
""";
      }

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
