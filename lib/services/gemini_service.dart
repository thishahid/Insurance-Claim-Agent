import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:insurance_claim_agent/config/api_config.dart';
import 'package:insurance_claim_agent/services/document_service.dart';

class GeminiService {
  GenerativeModel? _model; // Make it nullable
  final List<Content> _history = [];
  bool _isInitialized = false;

  // Define the system prompt that defines the AI's role and capabilities
  static const String _systemPrompt = """
You are an Insurance Claim Agent Assistant, a specialized AI designed to help with insurance-related queries. Your role is strictly limited to insurance topics including:

1. Insurance claim processes and procedures
2. Policy information and coverage details
3. Claim status updates and tracking
4. Documentation requirements for claims
5. Insurance terminology and concepts
6. General insurance industry knowledge

When asked about your capabilities, respond with:
"I can help you with various insurance-related tasks, including:
- Checking claim statuses
- Explaining insurance policies and coverage
- Guiding you through the claim process
- Answering questions about required documentation
- Providing information about insurance terminology
- Assisting with claim-related queries based on uploaded documents and dataset information

How can I assist you with your insurance needs today?"

If asked about topics outside the insurance domain, politely decline and redirect the conversation back to insurance-related matters.

Always maintain a professional, helpful, and empathetic tone, understanding that insurance matters can be stressful for users.

When provided with dataset information, use it as your primary source of knowledge for answering questions about policies, claims, and customer data.
""";

  Future<void> initialize() async {
    if (_isInitialized) return; // Already initialized

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

    // Initialize the conversation with the system prompt
    _history.add(Content.text(_systemPrompt));
    _isInitialized = true;
  }

  Future<String> generateResponse(
    String prompt, {
    String? documentContent,
    String? datasetContext,
  }) async {
    try {
      // Ensure the model is initialized
      if (!_isInitialized) {
        await initialize();
      }

      // Build the full prompt with document and dataset content if available
      String fullPrompt = prompt;

      if (documentContent != null || datasetContext != null) {
        fullPrompt =
            """
        User question: $prompt
        
        ${datasetContext != null ? "Relevant dataset information:\n$datasetContext\n\n" : ""}
        ${documentContent != null ? "Uploaded document content:\n${DocumentService.truncateText(documentContent)}\n\n" : ""}
        
        Please answer the user's question based on the provided information. If the information is not available, you can use your general knowledge but clearly indicate that.
        """;
      }

      // Add user message to history
      _history.add(Content.text(fullPrompt));

      // Generate response
      final response = await _model!.generateContent(
        _history,
      ); // Use ! since we've initialized it
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
    // Re-add the system prompt after clearing history
    _history.add(Content.text(_systemPrompt));
  }
}
