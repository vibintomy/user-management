import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/project_entity.dart';
import '../entities/lead_entity.dart';

abstract class ProjectRepository {
  Future<Either<Failure, ProjectEntity>> createProject({
    required String name,
    required String description,
    required String department,
    required String assignedLead,
    required DateTime deadline,
    String priority = 'medium',
  });

  Future<Either<Failure, List<ProjectEntity>>> getAllProjects({
    String? status,
    String? department,
    String? priority,
    int page = 1,
    int limit = 50,
  });

  Future<Either<Failure, List<LeadEntity>>> getAvailableLeads(String department);

  Future<Either<Failure, ProjectEntity>> getProject(String projectId);

  Future<Either<Failure, ProjectEntity>> updateProject({
    required String projectId,
    String? name,
    String? description,
    String? department,
    String? assignedLead,
    DateTime? deadline,
    String? priority,
    String? status,
  });

  Future<Either<Failure, void>> deleteProject(String projectId);
}