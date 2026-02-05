import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/exceptions.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart';
import 'package:manage_x/features/lead/domain/entities/module_entity.dart';
import 'package:manage_x/features/user/data/datasources/user_project_remote_datasource.dart';
import 'package:manage_x/features/user/domain/repositories/user_project_repository.dart';

class UserProjectRepositoryImpl implements UserProjectRepository {
  final UserProjectRemoteDataSource remoteDataSource;

  UserProjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProjectEntity>>> getMyProjects() async {
    try {
      final projects = await remoteDataSource.getMyProjects();
      return Right(projects);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> getProject(String projectId) async {
    try {
      final project = await remoteDataSource.getProject(projectId);
      return Right(project);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ModuleEntity>>> getModulesByProject(
      String projectId) async {
    try {
      final modules = await remoteDataSource.getModulesByProject(projectId);
      return Right(modules);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, ModuleEntity>> getModule(String moduleId) async {
    try {
      final module = await remoteDataSource.getModule(moduleId);
      return Right(module);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
    @override
  Future<Either<Failure, ModuleEntity>> updateModuleProgress({
    required String moduleId,
    required int progress,
  }) async {
    try {
      final module = await remoteDataSource.updateModuleProgress(
        moduleId: moduleId,
        progress: progress,
      );
      return Right(module);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}