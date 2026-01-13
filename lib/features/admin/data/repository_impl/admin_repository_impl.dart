import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';
import '../../domain/entities/pending_user_entity.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_datasource.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PendingUserEntity>>> getPendingUsers() async {
    try {
      final users = await remoteDataSource.getPendingUsers();
      return Right(users.map((model) => model.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get pending users: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> approveUser(String userId) async {
    try {
      final user = await remoteDataSource.approveUser(userId);
      return Right(user.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to approve user: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> rejectUser(
    String userId, {
    String? reason,
  }) async {
    try {
      await remoteDataSource.rejectUser(userId, reason: reason);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to reject user: $e'));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers({
    String? role,
    bool? isActive,
    String? department,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final users = await remoteDataSource.getAllUsers(
        role: role,
        isActive: isActive,
        department: department,
        page: page,
        limit: limit,
      );
      return Right(users.map((model) => model.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get users: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> toggleUserStatus(String userId) async {
    try {
      final user = await remoteDataSource.toggleUserStatus(userId);
      return Right(user.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to toggle user status: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String userId) async {
    try {
      await remoteDataSource.deleteUser(userId);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to delete user: $e'));
    }
  }
}