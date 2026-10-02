abstract class UsersDirectoryRepository {
  Future<List<String>> getUidsBySkill(String skill, {required String excludeUid});
}