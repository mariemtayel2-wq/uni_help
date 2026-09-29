import 'package:injectable/injectable.dart';

import 'package:uni_help/features/chat_screen/domain/repo/chat_repo.dart';

@lazySingleton
class SendMessageUseCase {
  const SendMessageUseCase(this._repository);

  final ChatRepository _repository;

  Future<void> call({required String chatId, required String text}) =>
      _repository.sendMessage(chatId: chatId, text: text);
}