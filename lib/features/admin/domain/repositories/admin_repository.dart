import 'package:dartz/dartz.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';
import '../../../../core/errors/failures.dart';
import '../entities/pending_user_entity.dart';

abstract class AdminRepository {
  /// Get pending approval users
  Future<Either<Failure, List<PendingUserEntity>>> getPendingUsers();

  /// Approve user
  Future<Either<Failure, UserEntity>> approveUser(String userId);

  /// Reject user
  Future<Either<Failure, void>> rejectUser(String userId, {String? reason});

  /// Get all users
  Future<Either<Failure, List<UserEntity>>> getAllUsers({
    String? role,
    bool? isActive,
    String? department,
    int page = 1,
    int limit = 50,
  });

  /// Toggle user status (block/unblock)
  Future<Either<Failure, UserEntity>> toggleUserStatus(String userId);

  /// Delete user
  Future<Either<Failure, void>> deleteUser(String userId);
}