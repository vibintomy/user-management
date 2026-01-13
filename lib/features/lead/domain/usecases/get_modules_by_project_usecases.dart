import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/lead/domain/entities/module_entity.dart';
import 'package:manage_x/features/lead/domain/repositories/lead_project_repositories.dart';

class GetModulesByProjectUseCase {
  final LeadProjectRepository repository;

  GetModulesByProjectUseCase(this.repository);

  Future<Either<Failure, List<ModuleEntity>>> call(String projectId) async {
    return await repository.getModulesByProject(projectId);
  }
}