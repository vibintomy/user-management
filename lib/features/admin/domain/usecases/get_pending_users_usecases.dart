import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/pending_user_entity.dart';
import '../repositories/admin_repository.dart';

class GetPendingUsersUseCase {
  final AdminRepository repository;

  GetPendingUsersUseCase(this.repository);

  Future<Either<Failure, List<PendingUserEntity>>> call() async {
    return await repository.getPendingUsers();
  }
}