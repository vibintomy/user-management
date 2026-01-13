import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/admin_repository.dart';

class RejectUserUseCase {
  final AdminRepository repository;

  RejectUserUseCase(this.repository);

  Future<Either<Failure, void>> call(
    String userId, {
    String? reason,
  }) async {
    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    return await repository.rejectUser(userId, reason: reason);
  }
}