import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> updateProfile({
    String? name,
    String? password,
    String? phone,
  });
}