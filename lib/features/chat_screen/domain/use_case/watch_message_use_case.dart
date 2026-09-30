import 'package:injectable/injectable.dart';


import 'package:uni_help/features/chat_screen/domain/entities/message_entity.dart';
import 'package:uni_help/features/chat_screen/domain/repo/chat_repo.dart';

@lazySingleton
class WatchMessagesUseCase {
  const WatchMessagesUseCase(this._repository);

  final ChatRepository _repository;

  Stream<List<MessageEntity>> call(String chatId) => _repository.watchMessages(chatId);
}