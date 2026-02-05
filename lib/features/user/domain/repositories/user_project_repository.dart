import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart';
import 'package:manage_x/features/lead/domain/entities/module_entity.dart';

abstract class UserProjectRepository {
  /// Get all projects where user is assigned
  Future<Either<Failure, List<ProjectEntity>>> getMyProjects();
  
  /// Get project details
  Future<Either<Failure, ProjectEntity>> getProject(String projectId);
  
  /// Get modules for a project
  Future<Either<Failure, List<ModuleEntity>>> getModulesByProject(String projectId);
  
  /// Get module details
  Future<Either<Failure, ModuleEntity>> getModule(String moduleId);
  Future<Either<Failure, ModuleEntity>> updateModuleProgress({
    required String moduleId,
    required int progress,
  });
}
