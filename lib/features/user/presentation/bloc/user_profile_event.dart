import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class RefreshProfileEvent extends ProfileEvent {}

class LogoutFromProfileEvent extends ProfileEvent {
  final String refreshToken;

  const LogoutFromProfileEvent({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];
}
class UpdateProfileEvent extends ProfileEvent {
  final String? name;
  final String? password;
  final String? phone;

  const UpdateProfileEvent({
    this.name,
    this.password,
    this.phone,
  });

  @override
  List<Object?> get props => [name, password, phone];
}