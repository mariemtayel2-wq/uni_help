import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/profile_entity.dart';
import 'package:uni_help/core/repositories/profile_repo.dart';

@lazySingleton
class WatchProfileUseCase {
  const WatchProfileUseCase(this._repo);
  final ProfileRepository _repo;
  Stream<ProfileEntity> call() => _repo.watchProfile();
}