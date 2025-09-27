import 'package:flutter/material.dart';
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
                    ? AppTheme.oliveGreen.withOpacity(0.8)
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
                    ? Border.all(color: AppTheme.oliveGreen.withOpacity(0.5))
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
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : AppTheme.textLight,
                    ),
                  ),
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
}
