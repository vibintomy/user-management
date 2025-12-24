import 'package:dartz/dartz.dart';
import 'package:manage_x/features/auth/domain/entities/auth_response_entities.dart';
import 'package:manage_x/features/auth/domain/repositories/auth_repositories.dart';
import '../../../../core/errors/failures.dart';


class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, AuthResponseEntity>> call({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
    String? department,
    String? fcmToken,
  }) async {
    // Validate role
    if (role != 'user' && role != 'lead') {
      return const Left(
        ValidationFailure('Invalid role. Must be either "user" or "lead"'),
      );
    }

    return await repository.register(
      name: name,
      email: email,
      password: password,
      role: role,
      phone: phone,
      department: department,
      fcmToken: fcmToken,
    );
  }
}