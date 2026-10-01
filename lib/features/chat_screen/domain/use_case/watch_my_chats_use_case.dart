import 'package:injectable/injectable.dart';
import 'package:uni_help/features/chat_screen/domain/entities/chat_summary_entity.dart';
import 'package:uni_help/features/chat_screen/domain/repo/chat_repo.dart';

@lazySingleton
class WatchMyChatsUseCase {
  const WatchMyChatsUseCase(this._repository);

  final ChatRepository _repository;

  Stream<List<ChatSummaryEntity>> call() => _repository.watchMyChats();
}