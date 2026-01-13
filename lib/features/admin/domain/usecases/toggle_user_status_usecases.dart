import 'package:dartz/dartz.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/admin_repository.dart';

class ToggleUserStatusUseCase {
  final AdminRepository repository;

  ToggleUserStatusUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String userId) async {
    if (userId.isEmpty) {
      return const Left(ValidationFailure('User ID cannot be empty'));
    }

    return await repository.toggleUserStatus(userId);
  }
}