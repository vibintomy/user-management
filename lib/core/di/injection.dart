import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:manage_x/core/networks/api_clients.dart';
import 'package:manage_x/core/storage/local_storage.dart';
import 'package:manage_x/core/storage/secure_storage.dart';
import 'package:manage_x/core/utils/notification_service.dart';
import 'package:manage_x/features/admin/presentation/bloc/project/project_bloc.dart';
import 'package:manage_x/features/admin/domain/repositories/project_repository.dart';
import 'package:manage_x/features/admin/domain/usecases/create_project_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/delete_project_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/get_all_projects_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/get_available_leads_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/update_project_usecases.dart';
import 'package:manage_x/features/admin/data/repository_impl/project_repository_impl.dart';
import 'package:manage_x/features/admin/data/datasources/project_remote_datasource.dart';
import 'package:manage_x/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:manage_x/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:manage_x/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:manage_x/features/auth/domain/repositories/auth_repositories.dart';
import 'package:manage_x/features/auth/domain/usecases/admin_login_usecases.dart';
import 'package:manage_x/features/auth/domain/usecases/get_current_user_usecases.dart';
import 'package:manage_x/features/auth/domain/usecases/login_usecases.dart';
import 'package:manage_x/features/auth/domain/usecases/logout_usecases.dart';
import 'package:manage_x/features/auth/domain/usecases/register_usecases.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_form_validation/login_form/login_form_cubit.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_form_validation/signup_form/signup_form_cubit.dart';
import 'package:manage_x/features/auth/presentation/bloc/password_visibility_bloc/password_visibility_cubit.dart';

// Admin imports
import 'package:manage_x/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:manage_x/features/admin/domain/repositories/admin_repository.dart'; // ADD THIS
import 'package:manage_x/features/admin/domain/usecases/approve_user_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/delete_user_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/get_all_users_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/get_pending_users_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/reject_user_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/toggle_user_status_usecases.dart';
import 'package:manage_x/features/admin/data/repository_impl/admin_repository_impl.dart';
import 'package:manage_x/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:manage_x/features/user/data/datasources/profile_remote_datasource.dart';
import 'package:manage_x/features/user/data/repositories/profile_repositories_impl.dart';
import 'package:manage_x/features/user/domain/repositories/profile_repository.dart';
import 'package:manage_x/features/user/domain/usecases/get_users_usecases.dart';
import 'package:manage_x/features/user/domain/usecases/logout_from_profile_usecases.dart';
import 'package:manage_x/features/user/domain/usecases/update_profile_usecases.dart';
import 'package:manage_x/features/user/presentation/bloc/user_profile_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDependency() async {
  // ============ Cubits/Blocs ============

  sl.registerFactory(() => PasswordVisibilityCubit());
  sl.registerFactory(() => LoginFormCubit());
  sl.registerFactory(() => SignupFormCubit());

  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      adminLoginUseCase: sl(),
      logoutUseCase: sl(),
      authLocalDataSource: sl(),
    ),
  );

  sl.registerFactory(
    () => AdminBloc(
      getPendingUsersUseCase: sl(),
      approveUserUseCase: sl(),
      rejectUserUseCase: sl(),
      getAllUsersUseCase: sl(),
      toggleUserStatusUseCase: sl(),
      deleteUserUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => ProjectBloc(
      createProjectUseCase: sl(),
      getAllProjectsUseCase: sl(),
      getAvailableLeadsUseCase: sl(),
      updateProjectUseCase: sl(),
      deleteProjectUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => ProfileBloc(
      getCurrentUserUseCase: sl(),
      logoutFromProfileUseCase: sl(),
      authLocalDataSource: sl(),
      updateProfileUseCase: sl(),
    ),
  );

  // ============ Auth Use Cases ============

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => AdminLoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // ============ Admin Use Cases ============
  // ============ Project Use Cases ============

  sl.registerLazySingleton(() => CreateProjectUseCase(sl()));
  sl.registerLazySingleton(() => GetAllProjectsUseCase(sl()));
  sl.registerLazySingleton(() => GetAvailableLeadsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProjectUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProjectUseCase(sl()));

  sl.registerLazySingleton(() => GetPendingUsersUseCase(sl()));
  sl.registerLazySingleton(() => ApproveUserUseCase(sl()));
  sl.registerLazySingleton(() => RejectUserUseCase(sl()));
  sl.registerLazySingleton(() => GetAllUsersUseCase(sl()));
  sl.registerLazySingleton(() => ToggleUserStatusUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUserUseCase(sl()));

  sl.registerLazySingleton(() => GetUsersUseCase(sl()));
  sl.registerLazySingleton(() => LogoutFromProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  // ============ Auth Repository ============

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // ============ Admin Repository ============ (FIXED)

  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: sl()),
  );

  // ============ Project Repository ============

  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // ============ Auth Data Sources ============

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl(), localStorage: sl()),
  );

  // ============ Admin Data Sources ============ (MOVED HERE)

  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(apiClient: sl()),
  );

  // ============ Project Data Sources ============

  sl.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(apiClient: sl(), localDataSource: sl()),
  );
  // ============ Core ============

  // API Client
  sl.registerLazySingleton(() => ApiClient(sl(), sl()));

  // Storage
  sl.registerLazySingleton(() => SecureStorage(sl()));
  sl.registerLazySingleton(() => LocalStorage(sl()));

  // Notification Service
  sl.registerLazySingleton(() => NotificationService());

  // ============ External ============

  // Dio
  sl.registerLazySingleton(() => Dio());

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Secure Storage
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
