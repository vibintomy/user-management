import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart';
import 'package:manage_x/features/lead/domain/repositories/lead_project_repositories.dart';

class GetAllProjectsUseCase {
  final LeadProjectRepository repository;

  GetAllProjectsUseCase(this.repository);

  Future<Either<Failure, List<ProjectEntity>>> call() async {
    return await repository.getAllProjects();
  }
}