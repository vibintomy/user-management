import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class UpdateProjectUseCase {
  final ProjectRepository repository;

  UpdateProjectUseCase(this.repository);

  Future<Either<Failure, ProjectEntity>> call({
    required String projectId,
    String? name,
    String? description,
    String? department,
    String? assignedLead,
    DateTime? deadline,
    String? priority,
    String? status,
  }) async {
    if (projectId.isEmpty) {
      return const Left(ValidationFailure('Project ID cannot be empty'));
    }

    return await repository.updateProject(
      projectId: projectId,
      name: name,
      description: description,
      department: department,
      assignedLead: assignedLead,
      deadline: deadline,
      priority: priority,
      status: status,
    );
  }
}