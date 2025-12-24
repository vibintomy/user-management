import 'package:dartz/dartz.dart';
import 'package:manage_x/features/auth/domain/repositories/auth_repositories.dart';
import '../../../../core/errors/failures.dart';


class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call(String refreshToken) async {
    return await repository.logout(refreshToken);
  }

  Future<Either<Failure, void>> logoutAll() async {
    return await repository.logoutAll();
  }
}