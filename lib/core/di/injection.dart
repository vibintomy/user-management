import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:manage_x/core/networks/api_clients.dart';
import 'package:manage_x/core/storage/local_storage.dart';
import 'package:manage_x/core/storage/secure_storage.dart';
import 'package:manage_x/core/utils/notification_service.dart';
import 'package:manage_x/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:manage_x/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:manage_x/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:manage_x/features/auth/domain/repositories/auth_repositories.dart';
import 'package:manage_x/features/auth/domain/usecases/admin_login_usecases.dart';
import 'package:manage_x/features/auth/domain/usecases/login_usecases.dart';
import 'package:manage_x/features/auth/domain/usecases/logout_usecases.dart';
import 'package:manage_x/features/auth/domain/usecases/register_usecases.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_form_validation/login_form/login_form_cubit.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_form_validation/signup_form/signup_form_cubit.dart';
import 'package:manage_x/features/auth/presentation/bloc/password_visibility_bloc/password_visibility_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDependency() async {
  sl.registerFactory(() => PasswordVisibilityCubit());
  sl.registerFactory(() => LoginFormCubit());
  sl.registerFactory(() => SignupFormCubit());
   sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        adminLoginUseCase: sl(),
        logoutUseCase: sl(),
        authLocalDataSource: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => AdminLoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorage: sl(),
      localStorage: sl(),
    ),
  );

  // ============ Core ============
  
  // API Client
  sl.registerLazySingleton(() => ApiClient(sl()));
  
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
