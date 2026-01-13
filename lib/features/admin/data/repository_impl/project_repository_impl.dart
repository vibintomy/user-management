import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/entities/lead_entity.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_remote_datasource.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProjectEntity>> createProject({
    required String name,
    required String description,
    required String department,
    required String assignedLead,
    required DateTime deadline,
    String priority = 'medium',
  }) async {
    try {
      final project = await remoteDataSource.createProject(
        name: name,
        description: description,
        department: department,
        assignedLead: assignedLead,
        deadline: deadline,
        priority: priority,
      );
      return Right(project.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to create project: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ProjectEntity>>> getAllProjects({
    String? status,
    String? department,
    String? priority,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final projects = await remoteDataSource.getAllProjects(
        status: status,
        department: department,
        priority: priority,
        page: page,
        limit: limit,
      );
      return Right(projects.map((model) => model.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get projects: $e'));
    }
  }

  @override
  Future<Either<Failure, List<LeadEntity>>> getAvailableLeads(
    String department,
  ) async {
    try {
      final leads = await remoteDataSource.getAvailableLeads(department);
      return Right(leads.map((model) => model.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get available leads: $e'));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> getProject(String projectId) async {
    try {
      final project = await remoteDataSource.getProject(projectId);
      return Right(project.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get project: $e'));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> updateProject({
    required String projectId,
    String? name,
    String? description,
    String? department,
    String? assignedLead,
    DateTime? deadline,
    String? priority,
    String? status,
  }) async {
    try {
      final project = await remoteDataSource.updateProject(
        projectId: projectId,
        name: name,
        description: description,
        department: department,
        assignedLead: assignedLead,
        deadline: deadline,
        priority: priority,
        status: status,
      );
      return Right(project.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update project: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProject(String projectId) async {
    try {
      await remoteDataSource.deleteProject(projectId);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to delete project: $e'));
    }
  }
}