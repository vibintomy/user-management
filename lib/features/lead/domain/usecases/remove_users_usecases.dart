import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart';
import 'package:manage_x/features/lead/domain/repositories/lead_project_repositories.dart';

class RemoveUserFromProjectUseCase {
  final LeadProjectRepository repository;

  RemoveUserFromProjectUseCase(this.repository);

  Future<Either<Failure, ProjectEntity>> call({
    required String projectId,
    required String userId,
  }) async {
    return await repository.removeUserFromProject(
      projectId: projectId,
      userId: userId,
    );
  }
}