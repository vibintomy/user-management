import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/lead/domain/entities/available_users_entity.dart';
import 'package:manage_x/features/lead/domain/repositories/lead_project_repositories.dart';

class GetAvailableUsersUseCase {
  final LeadProjectRepository repository;

  GetAvailableUsersUseCase(this.repository);

  Future<Either<Failure, List<AvailableUserEntity>>> call(String projectId) async {
    return await repository.getAvailableUsers(projectId);
  }
}