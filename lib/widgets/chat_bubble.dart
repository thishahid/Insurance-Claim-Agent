import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:insurance_claim_agent/config/theme.dart';
import 'package:insurance_claim_agent/models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onAttachmentTap;

  const ChatBubble({super.key, required this.message, this.onAttachmentTap});

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;
    final isSystem = message.type == MessageType.system;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser && !isSystem) ...[
            CircleAvatar(
              backgroundColor: AppTheme.oliveGreen,
              child: const Icon(Icons.smart_toy, color: Colors.white),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser
                    ? AppTheme.oliveGreen.withValues(alpha: 0.8)
                    : isSystem
                    ? AppTheme.cardBackground
                    : AppTheme.cardBackground,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                  bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                ),
                border: isSystem
                    ? Border.all(
                        color: AppTheme.oliveGreen.withValues(alpha: 0.5),
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isSystem)
                    Row(
                      children: const [
                        Icon(
                          Icons.info_outline,
                          color: AppTheme.oliveGreen,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'System Message',
                          style: TextStyle(
                            color: AppTheme.oliveGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  if (isSystem) const SizedBox(height: 8),

                  // Use Markdown for bot messages, regular text for user/system messages
                  isUser || isSystem
                      ? Text(
                          message.text,
                          style: TextStyle(
                            color: isUser ? Colors.white : AppTheme.textLight,
                          ),
                        )
                      : _buildMarkdownContent(context, message.text),

                  if (message.attachmentPath != null) ...[
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: onAttachmentTap,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.darkBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.insert_drive_file,
                              color: AppTheme.oliveGreen,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'View Attachment',
                              style: TextStyle(color: AppTheme.lightOlive),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: AppTheme.lightOlive,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMarkdownContent(BuildContext context, String text) {
    // Create a complete theme with all required text styles
    final baseTheme = ThemeData(
      brightness: Brightness.dark,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontSize: 16.0,
        ), // Explicitly set the required font size
        bodyLarge: TextStyle(fontSize: 16.0),
        bodySmall: TextStyle(fontSize: 14.0),
      ),
    );

    return MarkdownBody(
      data: text,
      styleSheet: MarkdownStyleSheet.fromTheme(baseTheme).copyWith(
        p: TextStyle(color: AppTheme.textLight, height: 1.5),
        h1: TextStyle(
          color: AppTheme.lightOlive,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        h2: TextStyle(
          color: AppTheme.lightOlive,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        h3: TextStyle(
          color: AppTheme.lightOlive,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        h4: TextStyle(
          color: AppTheme.lightOlive,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        h5: TextStyle(
          color: AppTheme.lightOlive,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        h6: TextStyle(
          color: AppTheme.lightOlive,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        strong: TextStyle(
          color: AppTheme.textLight,
          fontWeight: FontWeight.bold,
        ),
        em: TextStyle(color: AppTheme.textLight, fontStyle: FontStyle.italic),
        code: TextStyle(
          color: AppTheme.accentGreen,
          backgroundColor: AppTheme.darkBackground,
          fontFamily: 'monospace',
        ),
        codeblockDecoration: BoxDecoration(
          color: AppTheme.darkBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.oliveGreen.withValues(alpha: 0.3)),
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: AppTheme.oliveGreen, width: 4),
          ),
          color: AppTheme.cardBackground,
        ),
        listBullet: TextStyle(color: AppTheme.lightOlive),
        checkbox: TextStyle(color: AppTheme.lightOlive),
        tableBorder: TableBorder.all(
          color: AppTheme.oliveGreen.withValues(alpha: 0.3),
        ),
        tableHead: TextStyle(
          color: AppTheme.lightOlive,
          fontWeight: FontWeight.bold,
        ),
        tableBody: TextStyle(color: AppTheme.textLight),
      ),
      selectable: true,
      onTapLink: (text, href, title) {
        // Handle link taps
        if (href != null) {
          // In a real app, use url_launcher to open links
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Link tapped: $href'),
              backgroundColor: AppTheme.oliveGreen,
            ),
          );
        }
      },
    );
  }
}
