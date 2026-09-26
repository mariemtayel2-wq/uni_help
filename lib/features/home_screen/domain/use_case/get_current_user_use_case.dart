import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/current_user_entity.dart';

import 'package:uni_help/features/home_screen/domain/repo/home_repo.dart';

@lazySingleton
class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);

  final HomeRepository _repository;

  Future<CurrentUserEntity> call() => _repository.getCurrentUser();
}