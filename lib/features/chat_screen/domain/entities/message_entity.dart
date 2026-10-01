class MessageEntity {
  const MessageEntity({
    required this.id,
    required this.text,
    required this.senderId,
    required this.createdAt,
    this.isPending = false,
  });

  final String id;
  final String text;
  final String senderId;
  final DateTime createdAt;

  // الرسالة لسه ماوصلتش للسيرفر (hasPendingWrites).
  final bool isPending;

  bool isMine(String currentUserId) => senderId == currentUserId;
}