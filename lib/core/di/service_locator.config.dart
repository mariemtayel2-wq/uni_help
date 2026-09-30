// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:uni_help/core/reposatries/profile_repo.dart' as _i235;
import 'package:uni_help/core/reposatries/profile_repo_imp.dart' as _i507;
import 'package:uni_help/core/reposatries/rating_repo.dart' as _i1000;
import 'package:uni_help/core/reposatries/rating_repo_imp.dart' as _i126;
import 'package:uni_help/core/reposatries/request_repo.dart' as _i556;
import 'package:uni_help/core/reposatries/request_repo_imp.dart' as _i249;
import 'package:uni_help/core/reposatries/user_directory_repo.dart' as _i339;
import 'package:uni_help/core/reposatries/user_directory_repo_imp.dart'
    as _i104;
import 'package:uni_help/core/services/cloudinary_service.dart' as _i506;
import 'package:uni_help/core/services/local_notification.dart' as _i187;
import 'package:uni_help/core/services/notification_permision.dart' as _i44;
import 'package:uni_help/core/storage_helper/scure_storage_helper.dart'
    as _i101;
import 'package:uni_help/features/app_section/view_model/app_section_cubit.dart'
    as _i70;
import 'package:uni_help/features/authentication/data/repo/auth_remote_data_source_imp.dart'
    as _i266;
import 'package:uni_help/features/authentication/data/repo/auth_remote_repo_imp.dart'
    as _i551;
import 'package:uni_help/features/authentication/domain/repo/auth_remote_data_source.dart'
    as _i299;
import 'package:uni_help/features/authentication/domain/repo/auth_remote_repo.dart'
    as _i782;
import 'package:uni_help/features/authentication/domain/use_case/forget_pass_use_case.dart'
    as _i1026;
import 'package:uni_help/features/authentication/domain/use_case/google_in_use_case.dart'
    as _i378;
import 'package:uni_help/features/authentication/domain/use_case/log_in_use_case.dart'
    as _i778;
import 'package:uni_help/features/authentication/domain/use_case/register_use_case.dart'
    as _i470;
import 'package:uni_help/features/authentication/domain/use_case/resend_email_verification_use_case.dart'
    as _i462;
import 'package:uni_help/features/authentication/presentation/view_model/forget_cubit.dart'
    as _i718;
import 'package:uni_help/features/authentication/presentation/view_model/login_cubit.dart'
    as _i25;
import 'package:uni_help/features/authentication/presentation/view_model/register_cubit.dart'
    as _i50;
import 'package:uni_help/features/authentication/presentation/view_model/resend_verification_cubit.dart'
    as _i487;
import 'package:uni_help/features/chat_screen/data/repo/chat_data_source_imp.dart'
    as _i298;
import 'package:uni_help/features/chat_screen/data/repo/chat_repo_imp.dart'
    as _i28;
import 'package:uni_help/features/chat_screen/domain/repo/chat_data_source.dart'
    as _i543;
import 'package:uni_help/features/chat_screen/domain/repo/chat_repo.dart'
    as _i78;
import 'package:uni_help/features/chat_screen/domain/use_case/create_chat_use_case.dart'
    as _i29;
import 'package:uni_help/features/chat_screen/domain/use_case/send_message_use_case.dart'
    as _i37;
import 'package:uni_help/features/chat_screen/domain/use_case/watch_message_use_case.dart'
    as _i675;
import 'package:uni_help/features/chat_screen/presentation/view_model/chat_cubit.dart'
    as _i527;
import 'package:uni_help/features/create_request/data/repo/create_request_data_source_imp.dart'
    as _i784;
import 'package:uni_help/features/create_request/data/repo/create_request_repo_imp.dart'
    as _i1039;
import 'package:uni_help/features/create_request/domain/repo/request_data_source.dart'
    as _i700;
import 'package:uni_help/features/create_request/domain/repo/request_repo.dart'
    as _i409;
import 'package:uni_help/features/create_request/domain/use_case/create_request_use_case.dart'
    as _i183;
import 'package:uni_help/features/create_request/domain/use_case/notify_helpers_about_new_request_use_case.dart'
    as _i489;
import 'package:uni_help/features/create_request/presentation/view_model/create_request_cubit.dart'
    as _i720;
import 'package:uni_help/features/explore_screen/presentation/view_model/explore_cubit.dart'
    as _i928;
import 'package:uni_help/features/home_screen/data/repo/home_data_source_imp.dart'
    as _i685;
import 'package:uni_help/features/home_screen/data/repo/home_repo_imp.dart'
    as _i780;
import 'package:uni_help/features/home_screen/domain/repo/home_data_source_repo.dart'
    as _i412;
import 'package:uni_help/features/home_screen/domain/repo/home_repo.dart'
    as _i563;
import 'package:uni_help/features/home_screen/domain/use_case/get_current_user_use_case.dart'
    as _i749;
import 'package:uni_help/features/home_screen/domain/use_case/get_recent_request_use_case.dart'
    as _i66;
import 'package:uni_help/features/home_screen/presentation/view_model/home_cubit.dart'
    as _i221;
import 'package:uni_help/features/my_requests/domain/use_case/delete_request_use_case.dart'
    as _i310;
import 'package:uni_help/features/my_requests/domain/use_case/mark_request_as_read_use_case.dart'
    as _i690;
import 'package:uni_help/features/my_requests/domain/use_case/watch_request_use_case.dart'
    as _i876;
import 'package:uni_help/features/my_requests/presentation/view_model/my_request_cubit.dart'
    as _i730;
import 'package:uni_help/features/notification_screen/data/repo/notification_data_source_imp.dart'
    as _i906;
import 'package:uni_help/features/notification_screen/data/repo/notification_repo_imp.dart'
    as _i934;
import 'package:uni_help/features/notification_screen/domain/repo/notification_data_source.dart'
    as _i549;
import 'package:uni_help/features/notification_screen/domain/repo/notification_repo.dart'
    as _i237;
import 'package:uni_help/features/notification_screen/domain/use_case/make_all_as_read_use_case.dart'
    as _i752;
import 'package:uni_help/features/notification_screen/domain/use_case/mark_as_read_use_case.dart'
    as _i1002;
import 'package:uni_help/features/notification_screen/domain/use_case/send_notification_use_case.dart'
    as _i142;
import 'package:uni_help/features/notification_screen/domain/use_case/watch_notifications.dart'
    as _i1034;
import 'package:uni_help/features/notification_screen/presentation/view_model/notification_cubit.dart'
    as _i398;
import 'package:uni_help/features/profile_screen/domain/use_case/add_skills_use_case.dart'
    as _i295;
import 'package:uni_help/features/profile_screen/domain/use_case/get_profile_by_id_use_case.dart'
    as _i790;
import 'package:uni_help/features/profile_screen/domain/use_case/log_out_use_case.dart'
    as _i397;
import 'package:uni_help/features/profile_screen/domain/use_case/remove_skills_use_case.dart'
    as _i127;
import 'package:uni_help/features/profile_screen/domain/use_case/submit_rating_use_case.dart'
    as _i582;
import 'package:uni_help/features/profile_screen/domain/use_case/watch_profile_use_case.dart'
    as _i96;
import 'package:uni_help/features/profile_screen/presentation/view_model/profile_cubit.dart'
    as _i882;
import 'package:uni_help/features/rating/presentation/view_model/rating_cubit.dart'
    as _i53;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i70.AppSectionCubit>(() => _i70.AppSectionCubit());
    gh.lazySingleton<_i506.CloudinaryService>(() => _i506.CloudinaryService());
    gh.lazySingleton<_i101.SecureStorageHelper>(
      () => _i101.SecureStorageHelper(),
    );
    gh.lazySingleton<_i543.ChatRemoteDataSource>(
      () => _i298.ChatRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i299.AuthRemoteDataSource>(
      () => _i266.AuthRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i700.CreateRequestRemoteDataSource>(
      () => _i784.CreateRequestRemoteDataSourceImpl(
        firestore: gh<_i974.FirebaseFirestore>(),
        cloudinaryService: gh<_i506.CloudinaryService>(),
      ),
    );
    gh.lazySingleton<_i412.HomeRemoteDataSource>(
      () => _i685.HomeRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i78.ChatRepository>(
      () => _i28.ChatRepositoryImpl(gh<_i543.ChatRemoteDataSource>()),
    );
    gh.factory<_i409.CreateRequestRepository>(
      () => _i1039.CreateRequestRepositoryImpl(
        remoteDataSource: gh<_i700.CreateRequestRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i235.ProfileRepository>(
      () => _i507.ProfileRepositoryImpl(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i29.GetOrCreateChatUseCase>(
      () => _i29.GetOrCreateChatUseCase(gh<_i78.ChatRepository>()),
    );
    gh.lazySingleton<_i37.SendMessageUseCase>(
      () => _i37.SendMessageUseCase(gh<_i78.ChatRepository>()),
    );
    gh.lazySingleton<_i675.WatchMessagesUseCase>(
      () => _i675.WatchMessagesUseCase(gh<_i78.ChatRepository>()),
    );
    gh.factory<_i527.ChatCubit>(
      () => _i527.ChatCubit(
        gh<_i29.GetOrCreateChatUseCase>(),
        gh<_i675.WatchMessagesUseCase>(),
        gh<_i37.SendMessageUseCase>(),
      ),
    );
    gh.lazySingleton<_i1000.RatingRepository>(
      () => _i126.RatingRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i782.AuthRepository>(
      () => _i551.AuthRepositoryImpl(gh<_i299.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i1026.ForgotPasswordUseCase>(
      () => _i1026.ForgotPasswordUseCase(gh<_i782.AuthRepository>()),
    );
    gh.lazySingleton<_i378.GoogleSignInUseCase>(
      () => _i378.GoogleSignInUseCase(gh<_i782.AuthRepository>()),
    );
    gh.lazySingleton<_i778.LoginUseCase>(
      () => _i778.LoginUseCase(gh<_i782.AuthRepository>()),
    );
    gh.lazySingleton<_i470.RegisterUseCase>(
      () => _i470.RegisterUseCase(gh<_i782.AuthRepository>()),
    );
    gh.lazySingleton<_i462.ResendVerificationEmailUseCase>(
      () => _i462.ResendVerificationEmailUseCase(gh<_i782.AuthRepository>()),
    );
    gh.lazySingleton<_i549.NotificationsRemoteDataSource>(
      () => _i906.NotificationsRemoteDataSourceImpl(
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i187.LocalNotificationService>(
      () => _i187.LocalNotificationService(
        gh<_i163.FlutterLocalNotificationsPlugin>(),
      ),
    );
    gh.lazySingleton<_i563.HomeRepository>(
      () => _i780.HomeRepositoryImpl(gh<_i412.HomeRemoteDataSource>()),
    );
    gh.lazySingleton<_i183.CreateRequestUseCase>(
      () => _i183.CreateRequestUseCase(gh<_i409.CreateRequestRepository>()),
    );
    gh.lazySingleton<_i582.SubmitRatingUseCase>(
      () => _i582.SubmitRatingUseCase(gh<_i1000.RatingRepository>()),
    );
    gh.lazySingleton<_i397.LogoutUseCase>(
      () => _i397.LogoutUseCase(gh<_i59.FirebaseAuth>()),
    );
    gh.factory<_i25.LoginCubit>(
      () => _i25.LoginCubit(
        gh<_i778.LoginUseCase>(),
        gh<_i378.GoogleSignInUseCase>(),
      ),
    );
    gh.lazySingleton<_i556.RequestsRepository>(
      () => _i249.RequestsRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i44.NotificationPermissionService>(
      () => _i44.NotificationPermissionService(
        gh<_i163.FlutterLocalNotificationsPlugin>(),
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i339.UsersDirectoryRepository>(
      () => _i104.UsersDirectoryRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i310.DeleteRequestUseCase>(
      () => _i310.DeleteRequestUseCase(gh<_i556.RequestsRepository>()),
    );
    gh.lazySingleton<_i690.MarkRequestCompletedUseCase>(
      () => _i690.MarkRequestCompletedUseCase(gh<_i556.RequestsRepository>()),
    );
    gh.lazySingleton<_i876.WatchMyRequestsUseCase>(
      () => _i876.WatchMyRequestsUseCase(gh<_i556.RequestsRepository>()),
    );
    gh.lazySingleton<_i295.AddSkillUseCase>(
      () => _i295.AddSkillUseCase(gh<_i235.ProfileRepository>()),
    );
    gh.lazySingleton<_i790.GetProfileByIdUseCase>(
      () => _i790.GetProfileByIdUseCase(gh<_i235.ProfileRepository>()),
    );
    gh.lazySingleton<_i127.RemoveSkillUseCase>(
      () => _i127.RemoveSkillUseCase(gh<_i235.ProfileRepository>()),
    );
    gh.lazySingleton<_i96.WatchProfileUseCase>(
      () => _i96.WatchProfileUseCase(gh<_i235.ProfileRepository>()),
    );
    gh.factory<_i50.RegisterCubit>(
      () => _i50.RegisterCubit(gh<_i470.RegisterUseCase>()),
    );
    gh.lazySingleton<_i237.NotificationsRepository>(
      () => _i934.NotificationsRepositoryImpl(
        gh<_i549.NotificationsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i749.GetCurrentUserUseCase>(
      () => _i749.GetCurrentUserUseCase(gh<_i563.HomeRepository>()),
    );
    gh.lazySingleton<_i66.GetRecentRequestsUseCase>(
      () => _i66.GetRecentRequestsUseCase(gh<_i563.HomeRepository>()),
    );
    gh.factory<_i882.ProfileCubit>(
      () => _i882.ProfileCubit(
        watchProfileUseCase: gh<_i96.WatchProfileUseCase>(),
        addSkillUseCase: gh<_i295.AddSkillUseCase>(),
        removeSkillUseCase: gh<_i127.RemoveSkillUseCase>(),
        logoutUseCase: gh<_i397.LogoutUseCase>(),
      ),
    );
    gh.factory<_i487.ResendVerificationCubit>(
      () => _i487.ResendVerificationCubit(
        gh<_i462.ResendVerificationEmailUseCase>(),
      ),
    );
    gh.factory<_i718.ForgotPasswordCubit>(
      () => _i718.ForgotPasswordCubit(gh<_i1026.ForgotPasswordUseCase>()),
    );
    gh.factory<_i730.MyRequestsCubit>(
      () => _i730.MyRequestsCubit(
        gh<_i876.WatchMyRequestsUseCase>(),
        gh<_i310.DeleteRequestUseCase>(),
        gh<_i690.MarkRequestCompletedUseCase>(),
      ),
    );
    gh.factory<_i53.RateHelperCubit>(
      () => _i53.RateHelperCubit(
        gh<_i582.SubmitRatingUseCase>(),
        gh<_i749.GetCurrentUserUseCase>(),
      ),
    );
    gh.factory<_i221.HomeCubit>(
      () => _i221.HomeCubit(
        gh<_i749.GetCurrentUserUseCase>(),
        gh<_i66.GetRecentRequestsUseCase>(),
      ),
    );
    gh.lazySingleton<_i752.MarkAllNotificationsReadUseCase>(
      () => _i752.MarkAllNotificationsReadUseCase(
        gh<_i237.NotificationsRepository>(),
      ),
    );
    gh.lazySingleton<_i1002.MarkNotificationReadUseCase>(
      () => _i1002.MarkNotificationReadUseCase(
        gh<_i237.NotificationsRepository>(),
      ),
    );
    gh.lazySingleton<_i142.SendNotificationUseCase>(
      () => _i142.SendNotificationUseCase(gh<_i237.NotificationsRepository>()),
    );
    gh.lazySingleton<_i1034.WatchNotificationsUseCase>(
      () =>
          _i1034.WatchNotificationsUseCase(gh<_i237.NotificationsRepository>()),
    );
    gh.factory<_i928.ExploreCubit>(
      () => _i928.ExploreCubit(gh<_i66.GetRecentRequestsUseCase>()),
    );
    gh.factory<_i398.NotificationsCubit>(
      () => _i398.NotificationsCubit(
        watchNotificationsUseCase: gh<_i1034.WatchNotificationsUseCase>(),
        markAsReadUseCase: gh<_i1002.MarkNotificationReadUseCase>(),
        markAllAsReadUseCase: gh<_i752.MarkAllNotificationsReadUseCase>(),
        localNotificationService: gh<_i187.LocalNotificationService>(),
        permissionService: gh<_i44.NotificationPermissionService>(),
      ),
    );
    gh.lazySingleton<_i489.NotifyHelpersAboutNewRequestUseCase>(
      () => _i489.NotifyHelpersAboutNewRequestUseCase(
        gh<_i339.UsersDirectoryRepository>(),
        gh<_i142.SendNotificationUseCase>(),
      ),
    );
    gh.factory<_i720.CreateRequestCubit>(
      () => _i720.CreateRequestCubit(
        createRequestUseCase: gh<_i183.CreateRequestUseCase>(),
        getCurrentUserUseCase: gh<_i749.GetCurrentUserUseCase>(),
        notifyHelpersUseCase: gh<_i489.NotifyHelpersAboutNewRequestUseCase>(),
      ),
    );
    return this;
  }
}
