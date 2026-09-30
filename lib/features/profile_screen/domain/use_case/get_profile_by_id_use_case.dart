import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/profile_entity.dart';
import 'package:uni_help/core/reposatries/profile_repo.dart';

@lazySingleton
class GetProfileByIdUseCase {
  const GetProfileByIdUseCase(this._repo);
  final ProfileRepository _repo;
  Future<ProfileEntity> call(String uid) => _repo.getProfileById(uid);
}