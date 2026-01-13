import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/lead/domain/repositories/lead_project_repositories.dart';

class DeleteModuleUseCase {
  final LeadProjectRepository repository;

  DeleteModuleUseCase(this.repository);

  Future<Either<Failure, void>> call(String moduleId) async {
    return await repository.deleteModule(moduleId);
  }
}