import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_x/features/admin/domain/usecases/get_all_projects_usecases.dart';
import 'package:manage_x/features/lead/domain/usecases/assign_users_usecases.dart';
import 'package:manage_x/features/lead/domain/usecases/create_module_usecases.dart';
import 'package:manage_x/features/lead/domain/usecases/delete_module_usecases.dart';
import 'package:manage_x/features/lead/domain/usecases/get_available_users_usecases.dart';
import 'package:manage_x/features/lead/domain/usecases/get_modules_by_project_usecases.dart';
import 'package:manage_x/features/lead/domain/usecases/get_project_usecases.dart';
import 'package:manage_x/features/lead/domain/usecases/remove_users_usecases.dart';
import 'package:manage_x/features/lead/domain/usecases/update_module_progress_usecases.dart';
import 'package:manage_x/features/lead/domain/usecases/update_module_usecases.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_event.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_state.dart';

class LeadProjectBloc extends Bloc<LeadProjectEvent, LeadProjectState> {
  final GetAllProjectsUseCase getAllProjectsUseCase;
  final GetProjectUseCase getProjectUseCase;
  final GetModulesByProjectUseCase getModulesByProjectUseCase;
  final CreateModuleUseCase createModuleUseCase;
  final UpdateModuleUseCase updateModuleUseCase;
  final DeleteModuleUseCase deleteModuleUseCase;
  final UpdateModuleProgressUseCase updateModuleProgressUseCase;
  final AssignUsersToProjectUseCase assignUsersToProjectUseCase;
  final RemoveUserFromProjectUseCase removeUserFromProjectUseCase;
  final GetAvailableUsersUseCase getAvailableUsersUseCase;

  LeadProjectBloc({
    required this.getAllProjectsUseCase,
    required this.getProjectUseCase,
    required this.getModulesByProjectUseCase,
    required this.createModuleUseCase,
    required this.updateModuleUseCase,
    required this.deleteModuleUseCase,
    required this.updateModuleProgressUseCase,
    required this.assignUsersToProjectUseCase,
    required this.removeUserFromProjectUseCase,
    required this.getAvailableUsersUseCase,
  }) : super(LeadProjectInitial()) {
    on<LoadProjectsEvent>(_onLoadProjects);
    on<LoadProjectDetailsEvent>(_onLoadProjectDetails);
    on<LoadModulesEvent>(_onLoadModules);
    on<CreateModuleEvent>(_onCreateModule);
    on<UpdateModuleEvent>(_onUpdateModule);
    on<DeleteModuleEvent>(_onDeleteModule);
    on<UpdateModuleProgressEvent>(_onUpdateModuleProgress);
    on<LoadAvailableUsersEvent>(_onLoadAvailableUsers);
    on<AssignUsersEvent>(_onAssignUsers);
    on<RemoveUserEvent>(_onRemoveUser);
  }

  Future<void> _onLoadProjects(
    LoadProjectsEvent event,
    Emitter<LeadProjectState> emit,
  ) async {
    emit(LeadProjectLoading());

    final result = await getAllProjectsUseCase();

    result.fold(
      (failure) => emit(LeadProjectError(failure.message)),
      (projects) => emit(ProjectsLoaded(projects)),
    );
  }

  Future<void> _onLoadProjectDetails(
    LoadProjectDetailsEvent event,
    Emitter<LeadProjectState> emit,
  ) async {
    emit(LeadProjectLoading());

    final projectResult = await getProjectUseCase(event.projectId);
    final modulesResult = await getModulesByProjectUseCase(event.projectId);

    await projectResult.fold(
      (failure) async => emit(LeadProjectError(failure.message)),
      (project) async {
        await modulesResult.fold(
          (failure) async => emit(LeadProjectError(failure.message)),
          (modules) async => emit(ProjectDetailsLoaded(
            project: project,
            modules: modules,
          )),
        );
      },
    );
  }

  Future<void> _onLoadModules(
    LoadModulesEvent event,
    Emitter<LeadProjectState> emit,
  ) async {
    emit(LeadProjectLoading());

    final result = await getModulesByProjectUseCase(event.projectId);

    result.fold(
      (failure) => emit(LeadProjectError(failure.message)),
      (modules) => emit(ModulesLoaded(modules)),
    );
  }

  Future<void> _onCreateModule(
    CreateModuleEvent event,
    Emitter<LeadProjectState> emit,
  ) async {
    emit(LeadProjectLoading());

    final result = await createModuleUseCase(
      projectId: event.projectId,
      name: event.name,
      description: event.description,
      estimatedTime: event.estimatedTime,
      priority: event.priority,
      startDate: event.startDate,
      endDate: event.endDate,
      notes: event.notes,
    );

    result.fold(
      (failure) => emit(LeadProjectError(failure.message)),
      (module) => emit(ModuleCreated(module)),
    );
  }

  Future<void> _onUpdateModule(
    UpdateModuleEvent event,
    Emitter<LeadProjectState> emit,
  ) async {
    emit(LeadProjectLoading());

    final result = await updateModuleUseCase(
      moduleId: event.moduleId,
      name: event.name,
      description: event.description,
      estimatedTime: event.estimatedTime,
      priority: event.priority,
      status: event.status,
      startDate: event.startDate,
      endDate: event.endDate,
      notes: event.notes,
    );

    result.fold(
      (failure) => emit(LeadProjectError(failure.message)),
      (module) => emit(ModuleUpdated(module)),
    );
  }

  Future<void> _onDeleteModule(
    DeleteModuleEvent event,
    Emitter<LeadProjectState> emit,
  ) async {
    emit(LeadProjectLoading());

    final result = await deleteModuleUseCase(event.moduleId);

    result.fold(
      (failure) => emit(LeadProjectError(failure.message)),
      (_) => emit(const ModuleDeleted('Module deleted successfully')),
    );
  }

  Future<void> _onUpdateModuleProgress(
    UpdateModuleProgressEvent event,
    Emitter<LeadProjectState> emit,
  ) async {
    final result = await updateModuleProgressUseCase(
      moduleId: event.moduleId,
      progress: event.progress,
      actualTime: event.actualTime,
    );

    result.fold(
      (failure) => emit(LeadProjectError(failure.message)),
      (module) => emit(ModuleUpdated(module)),
    );
  }

  Future<void> _onLoadAvailableUsers(
    LoadAvailableUsersEvent event,
    Emitter<LeadProjectState> emit,
  ) async {
    emit(LeadProjectLoading());

    final result = await getAvailableUsersUseCase(event.projectId);

    result.fold(
      (failure) => emit(LeadProjectError(failure.message)),
      (users) => emit(AvailableUsersLoaded(users)),
    );
  }

  Future<void> _onAssignUsers(
    AssignUsersEvent event,
    Emitter<LeadProjectState> emit,
  ) async {
    emit(LeadProjectLoading());

    final result = await assignUsersToProjectUseCase(
      projectId: event.projectId,
      userIds: event.userIds,
    );

    result.fold(
      (failure) => emit(LeadProjectError(failure.message)),
      (project) => emit(UsersAssigned(
        project: project,
        message: 'Users assigned successfully',
      )),
    );
  }

  Future<void> _onRemoveUser(
    RemoveUserEvent event,
    Emitter<LeadProjectState> emit,
  ) async {
    emit(LeadProjectLoading());

    final result = await removeUserFromProjectUseCase(
      projectId: event.projectId,
      userId: event.userId,
    );

    result.fold(
      (failure) => emit(LeadProjectError(failure.message)),
      (project) => emit(UserRemoved(
        project: project,
        message: 'User removed successfully',
      )),
    );
  }
}