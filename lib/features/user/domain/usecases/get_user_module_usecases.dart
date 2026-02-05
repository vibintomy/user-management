import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/lead/domain/entities/module_entity.dart';
import 'package:manage_x/features/user/domain/repositories/user_project_repository.dart';

class GetUserModuleDetailsUseCase {
  final UserProjectRepository repository;

  GetUserModuleDetailsUseCase(this.repository);

  Future<Either<Failure, ModuleEntity>> call(String moduleId) async {
    return await repository.getModule(moduleId);
  }
}
