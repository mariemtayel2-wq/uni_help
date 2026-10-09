import 'package:uni_help/features/chat_screen/data/model/chat_summary_model.dart';
import 'package:uni_help/features/chat_screen/data/model/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<String> getOrCreateChat({
    required String requestId,
    required String requesterId,
    required String applicantId,
  });

  Stream<List<MessageModel>> watchMessages(String chatId);
  Future<void> sendMessage({required String chatId, required String text});

  Stream<List<ChatSummaryModel>> watchMyChats();

  Future<String> getUserName(String userId);
}