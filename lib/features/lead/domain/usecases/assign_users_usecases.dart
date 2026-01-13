import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart';
import 'package:manage_x/features/lead/domain/repositories/lead_project_repositories.dart';

class AssignUsersToProjectUseCase {
  final LeadProjectRepository repository;

  AssignUsersToProjectUseCase(this.repository);

  Future<Either<Failure, ProjectEntity>> call({
    required String projectId,
    required List<String> userIds,
  }) async {
    return await repository.assignUsersToProject(
      projectId: projectId,
      userIds: userIds,
    );
  }
}