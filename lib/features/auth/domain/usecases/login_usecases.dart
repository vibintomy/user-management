import 'package:dartz/dartz.dart';
import 'package:manage_x/features/auth/domain/entities/auth_response_entities.dart';
import 'package:manage_x/features/auth/domain/repositories/auth_repositories.dart';
import '../../../../core/errors/failures.dart';


class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, AuthResponseEntity>> call({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    return await repository.login(
      email: email,
      password: password,
      fcmToken: fcmToken,
    );
  }
}