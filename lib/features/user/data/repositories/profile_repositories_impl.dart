import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/exceptions.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';
import 'package:manage_x/features/user/data/datasources/profile_remote_datasource.dart';
import 'package:manage_x/features/user/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? name,
    String? password,
    String? phone,
  }) async {
    try {
      final updatedUser = await remoteDataSource.updateProfile(
        name: name,
        password: password,
        phone: phone,
      );

      // Cache the updated user data
      await localDataSource.cacheUser(updatedUser);

      return Right(updatedUser.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update profile: $e'));
    }
  }
}