import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class GetAllProjectsUseCase {
  final ProjectRepository repository;

  GetAllProjectsUseCase(this.repository);

  Future<Either<Failure, List<ProjectEntity>>> call({
    String? status,
    String? department,
    String? priority,
    int page = 1,
    int limit = 50,
  }) async {
    return await repository.getAllProjects(
      status: status,
      department: department,
      priority: priority,
      page: page,
      limit: limit,
    );
  }
}