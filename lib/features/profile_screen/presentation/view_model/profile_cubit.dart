import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/entities/profile_entity.dart';
import 'package:uni_help/core/services/presence_service.dart';
import 'package:uni_help/features/profile_screen/domain/use_case/add_skills_use_case.dart';
import 'package:uni_help/features/profile_screen/domain/use_case/watch_profile_use_case.dart';
import 'package:uni_help/features/profile_screen/domain/use_case/remove_skills_use_case.dart';
import 'package:uni_help/features/profile_screen/domain/use_case/log_out_use_case.dart';
import 'profile_state_cubit.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required this.watchProfileUseCase,
    required this.addSkillUseCase,
    required this.removeSkillUseCase,
    required this.logoutUseCase,
  }) : super(ProfileInitial());

  final WatchProfileUseCase watchProfileUseCase;
  final AddSkillUseCase addSkillUseCase;
  final RemoveSkillUseCase removeSkillUseCase;
  final LogoutUseCase logoutUseCase;

  StreamSubscription<ProfileEntity>? _sub;

  void listen() {
    emit(ProfileLoading());
    _sub?.cancel();
    _sub = watchProfileUseCase().listen(
      (profile) => emit(ProfileLoaded(profile)),
      onError: (e) => emit(ProfileError(e.toString())),
    );
  }

  Future<void> addSkill(String skill) => addSkillUseCase(skill);
  Future<void> removeSkill(String skill) => removeSkillUseCase(skill);

  Future<void> logout() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) await serviceLocator<PresenceService>().goOffline(uid);
    await logoutUseCase();
    emit(ProfileLoggedOut());
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}