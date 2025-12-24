import 'package:dartz/dartz.dart';
import 'package:manage_x/features/auth/domain/repositories/auth_repositories.dart';
import '../../../../core/errors/failures.dart';


class UpdateFcmTokenUseCase {
  final AuthRepository repository;

  UpdateFcmTokenUseCase(this.repository);

  Future<Either<Failure, void>> call(String fcmToken) async {
    if (fcmToken.isEmpty) {
      return const Left(ValidationFailure('FCM token cannot be empty'));
    }

    return await repository.updateFcmToken(fcmToken);
  }
}