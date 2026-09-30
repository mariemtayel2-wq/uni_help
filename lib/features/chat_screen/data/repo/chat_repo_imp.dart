import 'package:injectable/injectable.dart';
import 'package:uni_help/features/chat_screen/domain/entities/message_entity.dart';
import 'package:uni_help/features/chat_screen/domain/repo/chat_data_source.dart';
import 'package:uni_help/features/chat_screen/domain/repo/chat_repo.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._remoteDataSource);

  final ChatRemoteDataSource _remoteDataSource;

  @override
  Future<String> getOrCreateChat({required String requestId, required String requesterId}) =>
      _remoteDataSource.getOrCreateChat(requestId: requestId, requesterId: requesterId);

  @override
  Stream<List<MessageEntity>> watchMessages(String chatId) {
    return _remoteDataSource.watchMessages(chatId).map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<void> sendMessage({required String chatId, required String text}) =>
      _remoteDataSource.sendMessage(chatId: chatId, text: text);
}