import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';
import 'package:manage_x/features/auth/domain/repositories/auth_repositories.dart';

class GetUsersUseCase {
  final AuthRepository repository;

  GetUsersUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getCurrentUser();
  }
}