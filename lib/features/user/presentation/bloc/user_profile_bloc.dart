
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_x/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:manage_x/features/auth/domain/usecases/get_current_user_usecases.dart';
import 'package:manage_x/features/user/domain/usecases/logout_from_profile_usecases.dart';
import 'package:manage_x/features/user/domain/usecases/update_profile_usecases.dart';
import 'package:manage_x/features/user/presentation/bloc/user_profile_event.dart';
import 'package:manage_x/features/user/presentation/bloc/user_profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutFromProfileUseCase logoutFromProfileUseCase;
   final UpdateProfileUseCase updateProfileUseCase;
  final AuthLocalDataSource authLocalDataSource;

  ProfileBloc({
    required this.getCurrentUserUseCase,
    required this.logoutFromProfileUseCase,
      required this.updateProfileUseCase,
    required this.authLocalDataSource,
  }) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<RefreshProfileEvent>(_onRefreshProfile);
    on<LogoutFromProfileEvent>(_onLogout);
      on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final cachedUser = await authLocalDataSource.getStoredUser();
    if (cachedUser != null) { 
      emit(ProfileLoaded(user: cachedUser.toEntity()));
    }

    final result = await getCurrentUserUseCase();

    result.fold(
      (failure) {
    
        if (cachedUser != null) {
          // Show error but keep cached data visible
          emit(ProfileLoaded(user: cachedUser.toEntity()));
        } else {
          emit(ProfileError(message: failure.message));
        }
      },
      (user) => emit(ProfileLoaded(user: user)),
    );
  }

  Future<void> _onRefreshProfile(
    RefreshProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
   
    final result = await getCurrentUserUseCase();

    result.fold(
      (failure) {
       
        authLocalDataSource.getStoredUser().then((cachedUser) {
          if (cachedUser != null) {
            emit(ProfileLoaded(user: cachedUser.toEntity()));
          } else {
            emit(ProfileError(message: failure.message));
          }
        });
      },
      (user) => emit(ProfileLoaded(user: user)),
    );
  }

  Future<void> _onLogout(
    LogoutFromProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await logoutFromProfileUseCase(event.refreshToken);

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (_) => emit(ProfileLoggedOut()),
    );
  }
   Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileUpdating());

    final result = await updateProfileUseCase(
      name: event.name,
      password: event.password,
      phone: event.phone,
    );

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (user) => emit(ProfileUpdateSuccess(
        user: user,
        message: 'Profile updated successfully',
      )),
    );
  }
}

