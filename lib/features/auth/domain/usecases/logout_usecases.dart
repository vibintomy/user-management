import 'package:dartz/dartz.dart';
import 'package:manage_x/core/errors/failures.dart';
import 'package:manage_x/features/auth/domain/repositories/auth_repositories.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  /// Logs out from the current device
  /// - Sends refresh token to backend to revoke it
  /// - Always clears local auth data (tokens, user, flags)
  Future<Either<Failure, void>> call(String refreshToken) async {
    Either<Failure, void> serverResult = const Right(null);

    // Try to logout from server if refreshToken is provided
    if (refreshToken.isNotEmpty) {
      serverResult = await repository.logout(refreshToken);
    }

    // ALWAYS clear local data, regardless of server result
    // This ensures the user is immediately logged out on this device
    await repository.clearLocalAuthData();

    // Return the server result (success or failure), but local logout is guaranteed
    return serverResult;
  }

  /// Optional: Logout from all devices (if your backend supports it)
  /// Usually requires a different endpoint like /auth/logout-all
  Future<Either<Failure, void>> logoutAll() async {
    Either<Failure, void> serverResult = await repository.logoutAll();

    // Always clear local data after logout-all
    await repository.clearLocalAuthData();

    return serverResult;
  }
}