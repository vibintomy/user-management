import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';
import 'package:manage_x/features/user/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    String? name,
    String? password,
    String? phone,
  }) async {
    return await repository.updateProfile(
      name: name,
      password: password,
      phone: phone,
    );
  }
}