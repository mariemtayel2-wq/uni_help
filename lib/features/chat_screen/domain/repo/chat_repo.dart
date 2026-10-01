import 'package:uni_help/features/chat_screen/domain/entities/chat_summary_entity.dart';
import 'package:uni_help/features/chat_screen/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Future<String> getOrCreateChat({
    required String requestId,
    required String requesterId,
    required String applicantId,
  });

  Stream<List<MessageEntity>> watchMessages(String chatId);

  Future<void> sendMessage({required String chatId, required String text});

  Stream<List<ChatSummaryEntity>> watchMyChats();

  Future<String> getUserName(String userId);
}