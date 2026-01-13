import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/admin_repository.dart';

class DeleteUserUseCase {
  final AdminRepository repository;

  DeleteUserUseCase(this.repository);

  Future<Either<Failure, void>> call(String userId) async {
    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    return await repository.deleteUser(userId);
  }
}