import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_x/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';
import 'package:manage_x/features/auth/domain/usecases/admin_login_usecases.dart';
import 'package:manage_x/features/auth/domain/usecases/login_usecases.dart';
import 'package:manage_x/features/auth/domain/usecases/logout_usecases.dart';
import 'package:manage_x/features/auth/domain/usecases/register_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final AdminLoginUseCase adminLoginUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthLocalDataSource authLocalDataSource;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.adminLoginUseCase,
    required this.logoutUseCase,
    required this.authLocalDataSource,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<AdminLoginEvent>(_onAdminLogin);
    on<LogoutEvent>(_onLogout);
    on<UpdateFcmTokenEvent>(_onUpdateFcmToken);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final isLoggedIn = await authLocalDataSource.isLoggedIn();
    if (isLoggedIn) {
      final user = await authLocalDataSource.getStoredUser();
      if (user != null) {
        if (user.approved || user.isAdmin) {
          emit(Authenticated(user: user.toEntity()));
        } else {
          emit(PendingApproval(
            user: user.toEntity(),
            message: 'Your account is pending approval',
          ));
        }
        return;
      }
    }

    emit(Unauthenticated());
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      email: event.email,
      password: event.password,
      fcmToken: event.fcmToken,
    );

    result.fold(
      (failure) {
        if (failure.message.contains('pending approval') ||
            failure.message.contains('PENDING_APPROVAL')) {
          emit(PendingApproval(
            user: UserEntity(
              id: '',
              name: '',
              email: '',
              role: 'user',
              isActive: false,
              approved: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
            message: failure.message,
          ));
        } else {
          emit(AuthError(message: failure.message));
        }
      },
      (authResponse) {
        if (authResponse.user.approved || authResponse.user.isAdmin) {
          emit(Authenticated(user: authResponse.user));
        } else {
          emit(PendingApproval(
            user: authResponse.user,
            message: 'Your account is pending approval',
          ));
        }
      },
    );
  }

  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await registerUseCase(
      name: event.name,
      email: event.email,
      password: event.password,
      role: event.role,
      phone: event.phone,
      department: event.department,
      fcmToken: event.fcmToken,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (authResponse) {
        // After registration, user needs approval
        emit(PendingApproval(
          user: authResponse.user,
          message: 'Registration successful! Please wait for admin approval.',
        ));
      },
    );
  }

  Future<void> _onAdminLogin(
    AdminLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await adminLoginUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (authResponse) => emit(Authenticated(user: authResponse.user)),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await logoutUseCase(event.refreshToken);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onUpdateFcmToken(
    UpdateFcmTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    // Update FCM token silently without changing state
    await authLocalDataSource.cacheFcmToken(event.fcmToken);
  }
}