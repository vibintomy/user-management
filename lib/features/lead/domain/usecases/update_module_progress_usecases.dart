import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/lead/domain/entities/module_entity.dart';
import 'package:manage_x/features/lead/domain/repositories/lead_project_repositories.dart';

class UpdateModuleProgressUseCase {
  final LeadProjectRepository repository;

  UpdateModuleProgressUseCase(this.repository);

  Future<Either<Failure, ModuleEntity>> call({
    required String moduleId,
    required int progress,
    double? actualTime,
  }) async {
    return await repository.updateModuleProgress(
      moduleId: moduleId,
      progress: progress,
      actualTime: actualTime,
    );
  }
}