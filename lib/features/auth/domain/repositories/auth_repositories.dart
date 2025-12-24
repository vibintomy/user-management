import 'package:dartz/dartz.dart';
import 'package:manage_x/features/auth/domain/entities/auth_response_entities.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';
import '../../../../core/errors/failures.dart';


abstract class AuthRepository {
  /// User/Lead Login
  Future<Either<Failure, AuthResponseEntity>> login({
    required String email,
    required String password,
    String? fcmToken,
  });

  /// User/Lead Register
  Future<Either<Failure, AuthResponseEntity>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
    String? department,
    String? fcmToken,
  });

  /// Admin Login
  Future<Either<Failure, AuthResponseEntity>> adminLogin({
    required String email,
    required String password,
  });

  /// Logout
  Future<Either<Failure, void>> logout(String refreshToken);

  /// Logout from all devices
  Future<Either<Failure, void>> logoutAll();

  /// Get current user
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Update FCM Token
  Future<Either<Failure, void>> updateFcmToken(String fcmToken);

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Get stored user
  Future<UserEntity?> getStoredUser();

  /// Clear local data
  Future<void> clearLocalData();
}