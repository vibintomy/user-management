import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/lead/domain/entities/module_entity.dart';
import 'package:manage_x/features/user/domain/repositories/user_project_repository.dart';

class GetUserProjectModulesUseCase {
  final UserProjectRepository repository;

  GetUserProjectModulesUseCase(this.repository);

  Future<Either<Failure, List<ModuleEntity>>> call(String projectId) async {
    return await repository.getModulesByProject(projectId);
  }
}