import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/lead/domain/entities/module_entity.dart';
import 'package:manage_x/features/lead/domain/repositories/lead_project_repositories.dart';

class CreateModuleUseCase {
  final LeadProjectRepository repository;

  CreateModuleUseCase(this.repository);

  Future<Either<Failure, ModuleEntity>> call({
    required String projectId,
    required String name,
    String? description,
    required double estimatedTime,
    required String priority,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
     List<String>? assignedUsers,
  }) async {
    return await repository.createModule(
      projectId: projectId,
      name: name,
      description: description,
      estimatedTime: estimatedTime,
      priority: priority,
      startDate: startDate,
      endDate: endDate,
      notes: notes,
       assignedUsers: assignedUsers,
    );
  }
}