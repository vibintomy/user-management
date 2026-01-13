import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart';
import 'package:manage_x/features/lead/domain/repositories/lead_project_repositories.dart';

class GetProjectUseCase {
  final LeadProjectRepository repository;

  GetProjectUseCase(this.repository);

  Future<Either<Failure, ProjectEntity>> call(String projectId) async {
    return await repository.getProject(projectId);
  }
}