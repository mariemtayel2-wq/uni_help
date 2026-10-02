import 'package:injectable/injectable.dart';
import 'package:uni_help/core/repositories/profile_repo.dart';

@lazySingleton
class RemoveSkillUseCase {
  const RemoveSkillUseCase(this._repo);
  final ProfileRepository _repo;
  Future<void> call(String skill) => _repo.removeSkill(skill);
}