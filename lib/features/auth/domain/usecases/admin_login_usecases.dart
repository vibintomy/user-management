import 'package:dartz/dartz.dart';
import 'package:manage_x/features/auth/domain/entities/auth_response_entities.dart';
import 'package:manage_x/features/auth/domain/repositories/auth_repositories.dart';
import '../../../../core/errors/failures.dart';


class AdminLoginUseCase {
  final AuthRepository repository;

  AdminLoginUseCase(this.repository);

  Future<Either<Failure, AuthResponseEntity>> call({
    required String email,
    required String password,
  }) async {
    return await repository.adminLogin(
      email: email,
      password: password,
    );
  }
}