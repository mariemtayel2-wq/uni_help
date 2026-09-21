// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:uni_help/core/storage_helper/scure_storage_helper.dart'
    as _i101;
import 'package:uni_help/features/app_section/view_model/app_section_cubit.dart'
    as _i70;
import 'package:uni_help/features/authentication/data/repo/auth_remote_data_source_imp.dart'
    as _i266;
import 'package:uni_help/features/authentication/data/repo/auth_remote_repo_imp.dart'
    as _i551;
import 'package:uni_help/features/authentication/domain/repo/auth_remote_data_source.dart'
    as _i298;
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

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i70.AppSectionCubit>(() => _i70.AppSectionCubit());
    gh.lazySingleton<_i101.SecureStorageHelper>(
      () => _i101.SecureStorageHelper(),
    );
    gh.lazySingleton<_i298.AuthRemoteDataSource>(
      () => _i266.AuthRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i412.HomeRemoteDataSource>(
      () => _i685.HomeRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i782.AuthRepository>(
      () => _i551.AuthRepositoryImpl(gh<_i298.AuthRemoteDataSource>()),
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
    gh.lazySingleton<_i563.HomeRepository>(
      () => _i780.HomeRepositoryImpl(gh<_i412.HomeRemoteDataSource>()),
    );
    gh.factory<_i25.LoginCubit>(
      () => _i25.LoginCubit(
        gh<_i778.LoginUseCase>(),
        gh<_i378.GoogleSignInUseCase>(),
      ),
    );
    gh.factory<_i50.RegisterCubit>(
      () => _i50.RegisterCubit(gh<_i470.RegisterUseCase>()),
    );
    gh.lazySingleton<_i749.GetCurrentUserUseCase>(
      () => _i749.GetCurrentUserUseCase(gh<_i563.HomeRepository>()),
    );
    gh.lazySingleton<_i66.GetRecentRequestsUseCase>(
      () => _i66.GetRecentRequestsUseCase(gh<_i563.HomeRepository>()),
    );
    gh.factory<_i487.ResendVerificationCubit>(
      () => _i487.ResendVerificationCubit(
        gh<_i462.ResendVerificationEmailUseCase>(),
      ),
    );
    gh.factory<_i718.ForgotPasswordCubit>(
      () => _i718.ForgotPasswordCubit(gh<_i1026.ForgotPasswordUseCase>()),
    );
    gh.factory<_i221.HomeCubit>(
      () => _i221.HomeCubit(
        gh<_i749.GetCurrentUserUseCase>(),
        gh<_i66.GetRecentRequestsUseCase>(),
      ),
    );
    gh.factory<_i928.ExploreCubit>(
      () => _i928.ExploreCubit(gh<_i66.GetRecentRequestsUseCase>()),
    );
    return this;
  }
}
