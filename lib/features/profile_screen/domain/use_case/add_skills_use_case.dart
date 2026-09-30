import 'package:injectable/injectable.dart';
import 'package:uni_help/core/reposatries/profile_repo.dart';

@lazySingleton
class AddSkillUseCase {
  const AddSkillUseCase(this._repo);
  final ProfileRepository _repo;
  Future<void> call(String skill) => _repo.addSkill(skill);
}