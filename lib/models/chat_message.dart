enum MessageType { user, bot, system }

class ChatMessage {
  final String id;
  final String text;
  final MessageType type;
  final DateTime timestamp;
  final String? attachmentPath;

  ChatMessage({
    required this.id,
    required this.text,
    required this.type,
    required this.timestamp,
    this.attachmentPath,
  });

  factory ChatMessage.user({required String text, String? attachmentPath}) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      type: MessageType.user,
      timestamp: DateTime.now(),
      attachmentPath: attachmentPath,
    );
  }

  factory ChatMessage.bot({required String text}) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      type: MessageType.bot,
      timestamp: DateTime.now(),
    );
  }

  factory ChatMessage.system({required String text}) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      type: MessageType.system,
      timestamp: DateTime.now(),
    );
  }
}
