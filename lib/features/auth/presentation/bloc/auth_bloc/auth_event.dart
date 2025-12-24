import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  final String? fcmToken;

  const LoginEvent({
    required this.email,
    required this.password,
    this.fcmToken,
  });

  @override
  List<Object?> get props => [email, password, fcmToken];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String role;
  final String? phone;
  final String? department;
  final String? fcmToken;

  const RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.phone,
    this.department,
    this.fcmToken,
  });

  @override
  List<Object?> get props => [name, email, password, role, phone, department, fcmToken];
}

class AdminLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AdminLoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class LogoutEvent extends AuthEvent {
  final String refreshToken;

  const LogoutEvent({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];
}

class UpdateFcmTokenEvent extends AuthEvent {
  final String fcmToken;

  const UpdateFcmTokenEvent({required this.fcmToken});

  @override
  List<Object?> get props => [fcmToken];
}