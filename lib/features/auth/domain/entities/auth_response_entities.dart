import 'package:equatable/equatable.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';


class AuthResponseEntity extends Equatable {
  final bool success;
  final String message;
  final String accessToken;
  final String refreshToken;
  final UserEntity user;

  const AuthResponseEntity({
    required this.success,
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  @override
  List<Object?> get props => [
        success,
        message,
        accessToken,
        refreshToken,
        user,
      ];
}