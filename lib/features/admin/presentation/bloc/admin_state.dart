import 'package:equatable/equatable.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';
import '../../domain/entities/pending_user_entity.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class PendingUsersLoaded extends AdminState {
  final List<PendingUserEntity> users;

  const PendingUsersLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}

class UsersListLoaded extends AdminState {
  final List<UserEntity> users;

  const UsersListLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}

class UserApproved extends AdminState {
  final UserEntity user;

  const UserApproved({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserRejected extends AdminState {}

class UserStatusToggled extends AdminState {
  final UserEntity user;

  const UserStatusToggled({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserDeleted extends AdminState {}

class AdminError extends AdminState {
  final String message;

  const AdminError({required this.message});

  @override
  List<Object?> get props => [message];
}