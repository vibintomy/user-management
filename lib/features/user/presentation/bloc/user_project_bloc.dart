import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_x/features/lead/domain/usecases/update_module_progress_usecases.dart';
import 'package:manage_x/features/user/domain/usecases/get_my_project_usecases.dart';
import 'package:manage_x/features/user/domain/usecases/get_project_modules_usecases.dart';
import 'package:manage_x/features/user/domain/usecases/get_user_project_usecases.dart';
import 'package:manage_x/features/user/presentation/bloc/user_project_event.dart';
import 'package:manage_x/features/user/presentation/bloc/user_project_state.dart';

class UserProjectBloc extends Bloc<UserProjectEvent, UserProjectState> {
  final GetMyProjectsUseCase getMyProjectsUseCase;
  final GetUserProjectDetailsUseCase getUserProjectDetailsUseCase;
  final GetUserProjectModulesUseCase getUserProjectModulesUseCase;
  final UpdateModuleProgressUseCase updateModuleProgressUseCase;

  UserProjectBloc({
    required this.getMyProjectsUseCase,
    required this.getUserProjectDetailsUseCase,
    required this.getUserProjectModulesUseCase,
    required this.updateModuleProgressUseCase,
  }) : super(UserProjectInitial()) {
    on<LoadMyProjectsEvent>(_onLoadMyProjects);
    on<LoadUserProjectDetailsEvent>(_onLoadUserProjectDetails);
    on<RefreshUserProjectsEvent>(_onRefreshUserProjects);
    on<RefreshUserProjectDetailsEvent>(_onRefreshUserProjectDetails);
    on<UpdateModuleProgressEvent>(_onUpdateModuleProgress);
  }

  Future<void> _onLoadMyProjects(
    LoadMyProjectsEvent event,
    Emitter<UserProjectState> emit,
  ) async {
    emit(UserProjectLoading());

    final result = await getMyProjectsUseCase();

    result.fold(
      (failure) => emit(UserProjectError(failure.message)),
      (projects) => emit(MyProjectsLoaded(projects)),
    );
  }

  Future<void> _onLoadUserProjectDetails(
    LoadUserProjectDetailsEvent event,
    Emitter<UserProjectState> emit,
  ) async {
    emit(UserProjectLoading());

    final projectResult = await getUserProjectDetailsUseCase(event.projectId);
    final modulesResult = await getUserProjectModulesUseCase(event.projectId);

    await projectResult.fold(
      (failure) async => emit(UserProjectError(failure.message)),
      (project) async {
        await modulesResult.fold(
          (failure) async => emit(UserProjectError(failure.message)),
          (modules) async => emit(
            UserProjectDetailsLoaded(project: project, modules: modules),
          ),
        );
      },
    );
  }

  Future<void> _onRefreshUserProjects(
    RefreshUserProjectsEvent event,
    Emitter<UserProjectState> emit,
  ) async {
    // Don't show loading during refresh
    final result = await getMyProjectsUseCase();

    result.fold(
      (failure) => emit(UserProjectError(failure.message)),
      (projects) => emit(MyProjectsLoaded(projects)),
    );
  }

  Future<void> _onRefreshUserProjectDetails(
    RefreshUserProjectDetailsEvent event,
    Emitter<UserProjectState> emit,
  ) async {
    // Don't show loading during refresh
    final projectResult = await getUserProjectDetailsUseCase(event.projectId);
    final modulesResult = await getUserProjectModulesUseCase(event.projectId);

    await projectResult.fold(
      (failure) async => emit(UserProjectError(failure.message)),
      (project) async {
        await modulesResult.fold(
          (failure) async => emit(UserProjectError(failure.message)),
          (modules) async => emit(
            UserProjectDetailsLoaded(project: project, modules: modules),
          ),
        );
      },
    );
  }

  Future<void> _onUpdateModuleProgress(
    UpdateModuleProgressEvent event,
    Emitter<UserProjectState> emit,
  ) async {
    // Only handle if we are in details screen
    if (state is! UserProjectDetailsLoaded) return;

    final currentState = state as UserProjectDetailsLoaded;

    // 1. Optimistic update (instant UI feedback)
   final optimisticModules = currentState.modules.map((module) {
    if (module.id == event.moduleId) {
      return module.copyWith(
        progress: event.newProgress,
        // Optional: update status too for better UX
        status: event.newProgress == 100 ? 'completed' : 'in_progress',
      );
    }
      return module;
    }).toList();

    emit(
      UserProjectDetailsLoaded(
        project: currentState.project,
        modules: optimisticModules,
      ),
    );

    // 2. Call the actual update
    final result = await updateModuleProgressUseCase(
      moduleId: event.moduleId,
      progress: event.newProgress,
    );

    result.fold(
      (failure) {
        // 3. Revert optimistic update on failure + show error
        emit(
          UserProjectDetailsLoaded(
            project: currentState.project,
            modules: currentState.modules,
          ),
        );

        // You can also emit a temporary error state or just show snackbar
        emit(UserProjectError(failure.message));
      },
      (updatedModule) {
        // 4. Update with real server data
        final updatedModulesList = currentState.modules.map((module) {
          if (module.id == event.moduleId) {
            return updatedModule;
          }
          return module;
        }).toList();

        emit(
          UserProjectDetailsLoaded(
            project: currentState.project,
            modules: updatedModulesList,
          ),
        );
      },
    );
  }
}
