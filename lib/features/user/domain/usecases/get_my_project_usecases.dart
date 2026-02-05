import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart';
import 'package:manage_x/features/user/domain/repositories/user_project_repository.dart';

class GetMyProjectsUseCase {
  final UserProjectRepository repository;

  GetMyProjectsUseCase(this.repository);

  Future<Either<Failure, List<ProjectEntity>>> call() async {
    return await repository.getMyProjects();
  }
}