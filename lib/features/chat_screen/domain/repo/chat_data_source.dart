
import 'package:uni_help/features/chat_screen/data/model/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<String> getOrCreateChat({required String requestId, required String requesterId});

  Stream<List<MessageModel>> watchMessages(String chatId);
  Future<void> sendMessage({required String chatId, required String text});
}