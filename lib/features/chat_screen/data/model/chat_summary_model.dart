import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_help/features/chat_screen/domain/entities/chat_summary_entity.dart';

class ChatSummaryModel {
  const ChatSummaryModel({
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

  factory ChatSummaryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ChatSummaryModel(
      chatId: doc.id,
      requestId: data['requestId'] as String? ?? '',
      participants: List<String>.from(data['participants'] as List? ?? const []),
      lastMessage: data['lastMessage'] as String? ?? '',
      // نفس فكرة الرسايل: الـ serverTimestamp ممكن يبقى null مؤقتاً.
      lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  ChatSummaryEntity toEntity() => ChatSummaryEntity(
    chatId: chatId,
    requestId: requestId,
    participants: participants,
    lastMessage: lastMessage,
    lastMessageAt: lastMessageAt,
  );
}