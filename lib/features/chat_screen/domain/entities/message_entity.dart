class MessageEntity {
  const MessageEntity({
    required this.id,
    required this.text,
    required this.senderId,
    required this.createdAt,
  });

  final String id;
  final String text;
  final String senderId;
  final DateTime createdAt;

  bool isMine(String currentUserId) => senderId == currentUserId;
}