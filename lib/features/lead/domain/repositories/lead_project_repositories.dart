
import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart';
import 'package:manage_x/features/lead/domain/entities/available_users_entity.dart';
import 'package:manage_x/features/lead/domain/entities/module_entity.dart';

abstract class LeadProjectRepository {
  // Project operations
  Future<Either<Failure, List<ProjectEntity>>> getAllProjects();
  Future<Either<Failure, ProjectEntity>> getProject(String projectId);
  
  // Module operations
  Future<Either<Failure, List<ModuleEntity>>> getModulesByProject(String projectId);
  Future<Either<Failure, ModuleEntity>> getModule(String moduleId);
  Future<Either<Failure, ModuleEntity>> createModule({
    required String projectId,
    required String name,
    String? description,
    required double estimatedTime,
    required String priority,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
  });
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
  });
  Future<Either<Failure, void>> deleteModule(String moduleId);
  Future<Either<Failure, ModuleEntity>> updateModuleProgress({
    required String moduleId,
    required int progress,
    double? actualTime,
  });
  
  // User assignment
  Future<Either<Failure, ProjectEntity>> assignUsersToProject({
    required String projectId,
    required List<String> userIds,
  });
  Future<Either<Failure, ProjectEntity>> removeUserFromProject({
    required String projectId,
    required String userId,
  });
  Future<Either<Failure, List<AvailableUserEntity>>> getAvailableUsers(String projectId);
}
