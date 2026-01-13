import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/lead/domain/entities/module_entity.dart';
import 'package:manage_x/features/lead/domain/repositories/lead_project_repositories.dart';

class UpdateModuleUseCase {
  final LeadProjectRepository repository;

  UpdateModuleUseCase(this.repository);

  Future<Either<Failure, ModuleEntity>> call({
    required String moduleId,
    String? name,
    String? description,
    double? estimatedTime,
    String? priority,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
  }) async {
    return await repository.updateModule(
      moduleId: moduleId,
      name: name,
      description: description,
      estimatedTime: estimatedTime,
      priority: priority,
      status: status,
      startDate: startDate,
      endDate: endDate,
      notes: notes,
    );
  }
}