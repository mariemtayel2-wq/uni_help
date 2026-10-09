import 'package:injectable/injectable.dart';
import 'package:uni_help/features/chat_screen/domain/repo/chat_repo.dart';


@lazySingleton
class GetOrCreateChatUseCase {
  const GetOrCreateChatUseCase(this._repository);

  final ChatRepository _repository;

  Future<String> call({required String requestId, required String requesterId, required String applicantId}) =>
      _repository.getOrCreateChat(requestId: requestId, requesterId: requesterId, applicantId: applicantId);
}