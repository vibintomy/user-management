import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';
import '../repositories/admin_repository.dart';

class GetAllUsersUseCase {
  final AdminRepository repository;

  GetAllUsersUseCase(this.repository);

  Future<Either<Failure, List<UserEntity>>> call({
    String? role,
    bool? isActive,
    String? department,
    int page = 1,
    int limit = 50,
  }) async {
    return await repository.getAllUsers(
      role: role,
      isActive: isActive,
      department: department,
      page: page,
      limit: limit,
    );
  }
}