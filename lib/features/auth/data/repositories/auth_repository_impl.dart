import 'package:dartz/dartz.dart';
import 'package:manage_x/features/auth/domain/entities/auth_response_entities.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';
import 'package:manage_x/features/auth/domain/repositories/auth_repositories.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthResponseEntity>> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    try {
      final result = await remoteDataSource.login(
        email: email,
        password: password,
        fcmToken: fcmToken,
      );

      // Cache tokens and user data
      await localDataSource.cacheAuthTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      await localDataSource.cacheUser(result.user as UserModel);

      if (fcmToken != null) {
        await localDataSource.cacheFcmToken(fcmToken);
      }

      return Right(result.toEntity());
    } on PendingApprovalException catch (e) {
      return Left(PendingApprovalFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
    String? department,
    String? fcmToken,
  }) async {
    try {
      final result = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        role: role,
        phone: phone,
        department: department,
        fcmToken: fcmToken,
      );

      // Cache tokens and user data
      await localDataSource.cacheAuthTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      await localDataSource.cacheUser(result.user as UserModel);

      if (fcmToken != null) {
        await localDataSource.cacheFcmToken(fcmToken);
      }

      return Right(result.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> adminLogin({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.adminLogin(
        email: email,
        password: password,
      );

      // Cache tokens and user data
      await localDataSource.cacheAuthTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      await localDataSource.cacheUser(result.user as UserModel);

      return Right(result.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout(String refreshToken) async {
    try {
      await remoteDataSource.logout(refreshToken);
      await localDataSource.clearAuthData();
      return const Right(null);
    } on ServerException catch (e) {
      // Even if server logout fails, clear local data
      await localDataSource.clearAuthData();
      return Left(ServerFailure(e.message));
    } catch (e) {
      await localDataSource.clearAuthData();
      return Left(ServerFailure('Logout failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logoutAll() async {
    try {
      await remoteDataSource.logoutAll();
      await localDataSource.clearAuthData();
      return const Right(null);
    } on ServerException catch (e) {
      await localDataSource.clearAuthData();
      return Left(ServerFailure(e.message));
    } catch (e) {
      await localDataSource.clearAuthData();
      return Left(ServerFailure('Logout from all devices failed: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      await localDataSource.cacheUser(user);
      return Right(user.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      // Try to get cached user if network fails
      final cachedUser = await localDataSource.getStoredUser();
      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      }
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get user: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateFcmToken(String fcmToken) async {
    try {
      await remoteDataSource.updateFcmToken(fcmToken);
      await localDataSource.cacheFcmToken(fcmToken);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update FCM token: $e'));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localDataSource.isLoggedIn();
  }

  @override
  Future<UserEntity?> getStoredUser() async {
    final user = await localDataSource.getStoredUser();
    return user?.toEntity();
  }

  @override
  Future<void> clearLocalData() async {
    await localDataSource.clearAuthData();
  }
}