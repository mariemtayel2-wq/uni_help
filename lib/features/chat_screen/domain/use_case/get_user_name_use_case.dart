import 'package:injectable/injectable.dart';
import 'package:uni_help/features/chat_screen/domain/repo/chat_repo.dart';

@lazySingleton
class GetUserNameUseCase {
  const GetUserNameUseCase(this._repository);

  final ChatRepository _repository;

  Future<String> call(String userId) => _repository.getUserName(userId);
}