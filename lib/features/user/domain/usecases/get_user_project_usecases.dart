import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart';
import 'package:manage_x/features/user/domain/repositories/user_project_repository.dart';

class GetUserProjectDetailsUseCase {
  final UserProjectRepository repository;

  GetUserProjectDetailsUseCase(this.repository);

  Future<Either<Failure, ProjectEntity>> call(String projectId) async {
    return await repository.getProject(projectId);
  }
}
