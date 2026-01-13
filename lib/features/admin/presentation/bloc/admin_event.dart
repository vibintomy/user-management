import 'package:equatable/equatable.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

class GetPendingUsersEvent extends AdminEvent {}

class ApproveUserEvent extends AdminEvent {
  final String userId;

  const ApproveUserEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class RejectUserEvent extends AdminEvent {
  final String userId;
  final String? reason;

  const RejectUserEvent({required this.userId, this.reason});

  @override
  List<Object?> get props => [userId, reason];
}

class GetAllUsersEvent extends AdminEvent {
  final String? role;
  final bool? isActive;
  final String? department;

  const GetAllUsersEvent({
    this.role,
    this.isActive,
    this.department,
  });

  @override
  List<Object?> get props => [role, isActive, department];
}

class ToggleUserStatusEvent extends AdminEvent {
  final String userId;

  const ToggleUserStatusEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class DeleteUserEvent extends AdminEvent {
  final String userId;

  const DeleteUserEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}