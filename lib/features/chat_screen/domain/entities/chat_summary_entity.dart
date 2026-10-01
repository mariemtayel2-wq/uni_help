class ChatSummaryEntity {
  const ChatSummaryEntity({
    required this.chatId,
    required this.requestId,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageAt,
  });

  final String chatId;
  final String requestId;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageAt;

  // الـ participants بتتخزن دايماً [requesterId, applicantId].
  String get applicantId => participants.length > 1 ? participants[1] : '';

  String otherUserId(String currentUserId) =>
      participants.firstWhere((id) => id != currentUserId, orElse: () => '');
}