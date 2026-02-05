import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/lead/domain/entities/module_entity.dart';
import 'package:manage_x/features/user/domain/repositories/user_project_repository.dart';

class UpdateModuleProgressUseCase {
  final UserProjectRepository repository;

  UpdateModuleProgressUseCase(this.repository);

  Future<Either<Failure, ModuleEntity>> call({
    required String moduleId,
    required int progress,
  }) async {
    return await repository.updateModuleProgress(
      moduleId: moduleId,
      progress: progress,
    );
  }
}