import 'package:uni_help/core/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile();
  Stream<ProfileEntity> watchProfile();
  Stream<ProfileEntity> watchProfileById(String uid);
  Future<ProfileEntity> getProfileById(String uid);
  Future<void> addSkill(String skill);
  Future<void> removeSkill(String skill);
}