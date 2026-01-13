import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/auth/domain/repositories/auth_repositories.dart';

class LogoutFromProfileUseCase {
  final AuthRepository repository;

  LogoutFromProfileUseCase(this.repository);

  Future<Either<Failure, void>> call(String refreshToken) async {
    return await repository.logout(refreshToken);
  }
}