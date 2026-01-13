import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_x/features/admin/domain/usecases/approve_user_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/delete_user_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/get_all_users_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/get_pending_users_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/reject_user_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/toggle_user_status_usecases.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetPendingUsersUseCase getPendingUsersUseCase;
  final ApproveUserUseCase approveUserUseCase;
  final RejectUserUseCase rejectUserUseCase;
  final GetAllUsersUseCase getAllUsersUseCase;
  final ToggleUserStatusUseCase toggleUserStatusUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  AdminBloc({
    required this.getPendingUsersUseCase,
    required this.approveUserUseCase,
    required this.rejectUserUseCase,
    required this.getAllUsersUseCase,
    required this.toggleUserStatusUseCase,
    required this.deleteUserUseCase,
  }) : super(AdminInitial()) {
    on<GetPendingUsersEvent>(_onGetPendingUsers);
    on<ApproveUserEvent>(_onApproveUser);
    on<RejectUserEvent>(_onRejectUser);
    on<GetAllUsersEvent>(_onGetAllUsers);
    on<ToggleUserStatusEvent>(_onToggleUserStatus);
    on<DeleteUserEvent>(_onDeleteUser);
  }

  Future<void> _onGetPendingUsers(
    GetPendingUsersEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await getPendingUsersUseCase();

    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (users) => emit(PendingUsersLoaded(users: users)),
    );
  }

  Future<void> _onApproveUser(
    ApproveUserEvent event,
    Emitter<AdminState> emit,
  ) async {

    final result = await approveUserUseCase(event.userId);

    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (user) => emit(UserApproved(user: user)),
    );
  }

 Future<void> _onRejectUser(
  RejectUserEvent event,
  Emitter<AdminState> emit,
) async {
  // First: Reject the user (optional: save reason, send email, etc.)
  final rejectResult = await rejectUserUseCase(event.userId, reason: event.reason);

  if (rejectResult.isLeft()) {
    final failure = rejectResult.fold((l) => l, (_) => null);
    emit(AdminError(message: failure!.message));
    return;
  }

  // If reject succeeded (or even if you skip reject logic), DELETE the user
  final deleteResult = await deleteUserUseCase(event.userId);

  deleteResult.fold(
    (failure) => emit(AdminError(message: failure.message)),
    (_) => emit(UserRejected()), // or create a new state like UserDeletedAfterReject()
  );
}

  Future<void> _onGetAllUsers(
    GetAllUsersEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await getAllUsersUseCase(
      role: event.role,
      isActive: event.isActive,
      department: event.department,
    );

    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (users) => emit(UsersListLoaded(users: users)),
    );
  }

  Future<void> _onToggleUserStatus(
    ToggleUserStatusEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await toggleUserStatusUseCase(event.userId);

    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (user) => emit(UserStatusToggled(user: user)),
    );
  }

  Future<void> _onDeleteUser(
    DeleteUserEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await deleteUserUseCase(event.userId);

    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (_) => emit(UserDeleted()),
    );
  }
}