import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';
import '../repositories/admin_repository.dart';

class ApproveUserUseCase {
  final AdminRepository repository;

  ApproveUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String userId) async {
    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    return await repository.approveUser(userId);
  }
}