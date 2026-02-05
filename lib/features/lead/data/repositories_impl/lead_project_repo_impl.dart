
import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/exceptions.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart';
import 'package:manage_x/features/lead/data/datasource/lead_project_remote_datasource.dart';
import 'package:manage_x/features/lead/domain/entities/available_users_entity.dart';
import 'package:manage_x/features/lead/domain/entities/module_entity.dart';
import 'package:manage_x/features/lead/domain/repositories/lead_project_repositories.dart';

class LeadProjectRepositoryImpl implements LeadProjectRepository {
  final LeadProjectRemoteDataSource remoteDataSource;

  LeadProjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProjectEntity>>> getAllProjects() async {
    try {
      final projects = await remoteDataSource.getAllProjects();
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
  Future<Either<Failure, List<ModuleEntity>>> getModulesByProject(String projectId) async {
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
  Future<Either<Failure, ModuleEntity>> createModule({
    required String projectId,
    required String name,
    String? description,
    required double estimatedTime,
    required String priority,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
      List<String>? assignedUsers
  }) async {
    try {
      final data = {
        'name': name,
        if (description != null) 'description': description,
        'estimatedTime': estimatedTime,
        'priority': priority,
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
        if (notes != null) 'notes': notes,
         if (assignedUsers != null && assignedUsers.isNotEmpty) 
        'assignedUsers': assignedUsers, 
      };

      final module = await remoteDataSource.createModule(projectId, data);
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
  Future<Either<Failure, ModuleEntity>> updateModule({
    required String moduleId,
    String? name,
    String? description,
    double? estimatedTime,
    String? priority,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (estimatedTime != null) data['estimatedTime'] = estimatedTime;
      if (priority != null) data['priority'] = priority;
      if (status != null) data['status'] = status;
      if (startDate != null) data['startDate'] = startDate.toIso8601String();
      if (endDate != null) data['endDate'] = endDate.toIso8601String();
      if (notes != null) data['notes'] = notes;

      final module = await remoteDataSource.updateModule(moduleId, data);
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
  Future<Either<Failure, void>> deleteModule(String moduleId) async {
    try {
      await remoteDataSource.deleteModule(moduleId);
      return const Right(null);
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
    double? actualTime,
  }) async {
    try {
      final data = {
        'progress': progress,
        if (actualTime != null) 'actualTime': actualTime,
      };

      final module = await remoteDataSource.updateModuleProgress(moduleId, data);
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
  Future<Either<Failure, ProjectEntity>> assignUsersToProject({
    required String projectId,
    required List<String> userIds,
  }) async {
    try {
      final project = await remoteDataSource.assignUsersToProject(projectId, userIds);
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
  Future<Either<Failure, ProjectEntity>> removeUserFromProject({
    required String projectId,
    required String userId,
  }) async {
    try {
      final project = await remoteDataSource.removeUserFromProject(projectId, userId);
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
  Future<Either<Failure, List<AvailableUserEntity>>> getAvailableUsers(String projectId) async {
    try {
      final users = await remoteDataSource.getAvailableUsers(projectId);
      return Right(users);
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