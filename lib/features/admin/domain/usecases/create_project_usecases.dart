import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class CreateProjectUseCase {
  final ProjectRepository repository;

  CreateProjectUseCase(this.repository);

  Future<Either<Failure, ProjectEntity>> call({
    required String name,
    required String description,
    required String department,
    required String assignedLead,
    required DateTime deadline,
    String priority = 'medium',
  }) async {
    if (name.isEmpty) {
      return const Left(ValidationFailure('Project name cannot be empty'));
    }

    if (description.isEmpty) {
      return const Left(ValidationFailure('Description cannot be empty'));
    }

    if (department.isEmpty) {
      return const Left(ValidationFailure('Department cannot be empty'));
    }

    if (assignedLead.isEmpty) {
      return const Left(ValidationFailure('Please select a lead'));
    }

    return await repository.createProject(
      name: name,
      description: description,
      department: department,
      assignedLead: assignedLead,
      deadline: deadline,
      priority: priority,
    );
  }
}