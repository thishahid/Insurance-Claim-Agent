import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:insurance_claim_agent/config/theme.dart';
import 'package:insurance_claim_agent/models/chat_message.dart';
import 'package:insurance_claim_agent/services/gemini_service.dart';
import 'package:insurance_claim_agent/services/document_service.dart';
import 'package:insurance_claim_agent/widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GeminiService _geminiService = GeminiService();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  File? _selectedFile;
  String? _documentContent; // Store extracted document content
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeGemini();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _initializeGemini() async {
    try {
      await _geminiService.initialize();
    } catch (e) {
      _addSystemMessage('Failed to initialize AI service: ${e.toString()}');
    }
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(
        ChatMessage.bot(
          text:
              'Hello! I\'m your insurance assistant. You can ask about claims, policies, or upload a document (TXT, PDF, DOC, DOCX) and I\'ll answer questions based on its content.',
        ),
      );
    });
  }

  void _addSystemMessage(String text) {
    setState(() {
      _messages.add(ChatMessage.system(text: text));
    });
    _scrollToBottom();
  }

  Future<void> _handleSendMessage() async {
    if (_textController.text.isEmpty && _selectedFile == null) return;

    final userMessage = _textController.text;
    _textController.clear();

    // If a file is selected, process it
    if (_selectedFile != null) {
      try {
        _addSystemMessage('Processing document...');
        _documentContent = await DocumentService.extractTextFromFile(
          _selectedFile!,
        );
        _addSystemMessage(
          'Document processed successfully. You can now ask questions about its content.',
        );
      } catch (e) {
        _addSystemMessage('Error processing document: ${e.toString()}');
        setState(() {
          _selectedFile = null;
        });
        return;
      }
    }

    setState(() {
      _messages.add(
        ChatMessage.user(
          text: userMessage,
          attachmentPath: _selectedFile?.path,
        ),
      );
      _isLoading = true;
      _selectedFile = null;
    });

    _scrollToBottom();

    try {
      final response = await _geminiService.generateResponse(
        userMessage,
        documentContent: _documentContent, // Pass document content
      );

      setState(() {
        _messages.add(ChatMessage.bot(text: response));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage.bot(text: 'Error: ${e.toString()}'));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _clearDocumentContext() {
    setState(() {
      _documentContent = null;
    });
    _addSystemMessage(
      'Document context cleared. You can upload a new document if needed.',
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Document context indicator
        if (_documentContent != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppTheme.oliveGreen.withValues(alpha: 0.2),
            child: Row(
              children: [
                const Icon(Icons.description, color: AppTheme.oliveGreen),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Document context is active',
                    style: TextStyle(color: AppTheme.textLight),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear, color: AppTheme.textDark),
                  onPressed: _clearDocumentContext,
                  tooltip: 'Clear document context',
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return ChatBubble(
                message: message,
                onAttachmentTap: message.attachmentPath != null
                    ? () => _showAttachmentDialog(message.attachmentPath!)
                    : null,
              );
            },
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.oliveGreen),
              ),
            ),
          ),
        _buildMessageComposer(),
      ],
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (_selectedFile != null)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppTheme.oliveGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.insert_drive_file,
                    color: AppTheme.oliveGreen,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedFile!.path.split('/').last,
                      style: const TextStyle(color: AppTheme.textLight),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.textDark),
                    onPressed: () {
                      setState(() {
                        _selectedFile = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file, color: AppTheme.oliveGreen),
                onPressed: _pickFile,
                tooltip: 'Upload document',
              ),
              IconButton(
                icon: const Icon(Icons.mic, color: AppTheme.oliveGreen),
                onPressed: () {
                  // Voice input feature
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Voice input feature coming soon!'),
                      backgroundColor: AppTheme.oliveGreen,
                    ),
                  );
                },
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: _documentContent != null
                        ? 'Ask about the document...'
                        : 'Ask about claims, policies, or upload a document...',
                    hintStyle: TextStyle(color: AppTheme.textDark),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: const TextStyle(color: AppTheme.textLight),
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _handleSendMessage(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: AppTheme.oliveGreen,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _handleSendMessage,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAttachmentDialog(String path) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Attachment'),
        content: Text('File: ${path.split('/').last}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
