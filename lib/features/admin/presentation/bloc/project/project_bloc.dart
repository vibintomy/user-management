import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_x/features/admin/domain/usecases/create_project_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/delete_project_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/get_all_projects_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/get_available_leads_usecases.dart';
import 'package:manage_x/features/admin/domain/usecases/update_project_usecases.dart';
import 'package:manage_x/features/admin/presentation/bloc/project/project_event.dart';
import 'package:manage_x/features/admin/presentation/bloc/project/project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final CreateProjectUseCase createProjectUseCase;
  final GetAllProjectsUseCase getAllProjectsUseCase;
  final GetAvailableLeadsUseCase getAvailableLeadsUseCase;
  final UpdateProjectUseCase updateProjectUseCase;
  final DeleteProjectUseCase deleteProjectUseCase;

  ProjectBloc({
    required this.createProjectUseCase,
    required this.getAllProjectsUseCase,
    required this.getAvailableLeadsUseCase,
    required this.updateProjectUseCase,
    required this.deleteProjectUseCase,
  }) : super(ProjectInitial()) {
    on<GetAllProjectsEvent>(_onGetAllProjects);
    on<GetAvailableLeadsEvent>(_onGetAvailableLeads);
    on<CreateProjectEvent>(_onCreateProject);
    on<UpdateProjectEvent>(_onUpdateProject);
    on<DeleteProjectEvent>(_onDeleteProject);
  }

  Future<void> _onGetAllProjects(
    GetAllProjectsEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());

    final result = await getAllProjectsUseCase(
      status: event.status,
      department: event.department,
      priority: event.priority,
    );

    result.fold(
      (failure) => emit(ProjectError(message: failure.message)),
      (projects) => emit(ProjectsLoaded(projects: projects)),
    );
  }

  Future<void> _onGetAvailableLeads(
    GetAvailableLeadsEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());

    final result = await getAvailableLeadsUseCase(event.department);

    result.fold(
      (failure) => emit(ProjectError(message: failure.message)),
      (leads) => emit(LeadsLoaded(leads: leads)),
    );
  }

  Future<void> _onCreateProject(
    CreateProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());

    final result = await createProjectUseCase(
      name: event.name,
      description: event.description,
      department: event.department,
      assignedLead: event.assignedLead,
      deadline: event.deadline,
      priority: event.priority,
    );

    result.fold(
      (failure) => emit(ProjectError(message: failure.message)),
      (project) => emit(ProjectCreated(project: project)),
    );
  }

  Future<void> _onUpdateProject(
    UpdateProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());

    final result = await updateProjectUseCase(
      projectId: event.projectId,
      name: event.name,
      description: event.description,
      department: event.department,
      assignedLead: event.assignedLead,
      deadline: event.deadline,
      priority: event.priority,
      status: event.status,
    );

    result.fold(
      (failure) => emit(ProjectError(message: failure.message)),
      (project) => emit(ProjectUpdated(project: project)),
    );
  }

  Future<void> _onDeleteProject(
    DeleteProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());

    final result = await deleteProjectUseCase(event.projectId);

    result.fold(
      (failure) => emit(ProjectError(message: failure.message)),
      (_) => emit(ProjectDeleted()),
    );
  }
}
