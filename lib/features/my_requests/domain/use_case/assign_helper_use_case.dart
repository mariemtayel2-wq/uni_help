import 'package:injectable/injectable.dart';
import 'package:uni_help/core/repositories/request_repo.dart';

@lazySingleton
class AssignHelperUseCase {
  const AssignHelperUseCase(this._repository);

  final RequestsRepository _repository;

  Future<void> call({
    required String requestId,
    required String helperId,
    required String helperName,
  }) =>
      _repository.assignHelper(
        requestId: requestId,
        helperId: helperId,
        helperName: helperName,
      );
}
