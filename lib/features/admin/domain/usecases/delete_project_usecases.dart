import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/project_repository.dart';

class DeleteProjectUseCase {
  final ProjectRepository repository;

  DeleteProjectUseCase(this.repository);

  Future<Either<Failure, void>> call(String projectId) async {
    if (projectId.isEmpty) {
      return const Left(ValidationFailure('Project ID cannot be empty'));
    }

    return await repository.deleteProject(projectId);
  }
}