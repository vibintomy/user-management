import 'package:dartz/dartz.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';
import 'package:manage_x/features/auth/domain/repositories/auth_repositories.dart';
import '../../../../core/errors/failures.dart';


class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getCurrentUser();
  }

  Future<UserEntity?> getStoredUser() async {
    return await repository.getStoredUser();
  }

  Future<bool> isLoggedIn() async {
    return await repository.isLoggedIn();
  }
}


