import 'package:equatable/equatable.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart';
import 'package:manage_x/features/lead/domain/entities/available_users_entity.dart';
import 'package:manage_x/features/lead/domain/entities/module_entity.dart';

abstract class LeadProjectState extends Equatable {
  const LeadProjectState();

  @override
  List<Object?> get props => [];
}

class LeadProjectInitial extends LeadProjectState {}

class LeadProjectLoading extends LeadProjectState {}

// Projects States
class ProjectsLoaded extends LeadProjectState {
  final List<ProjectEntity> projects;

  const ProjectsLoaded(this.projects);

  @override
  List<Object?> get props => [projects];
}

class ProjectDetailsLoaded extends LeadProjectState {
  final ProjectEntity project;
  final List<ModuleEntity> modules;
  final List<AvailableUserEntity> availableUsers;
  final String? availableUsersError;

  const ProjectDetailsLoaded({
    required this.project,
    required this.modules,
    this.availableUsers = const [],
    this.availableUsersError,
  });

  @override
  List<Object?> get props => [
    project,
    modules,
    availableUsers,
    availableUsersError,
  ];
}

// Modules States
class ModulesLoaded extends LeadProjectState {
  final List<ModuleEntity> modules;

  const ModulesLoaded(this.modules);

  @override
  List<Object?> get props => [modules];
}

class ModuleCreated extends LeadProjectState {
  final ModuleEntity module;

  const ModuleCreated(this.module);

  @override
  List<Object?> get props => [module];
}

class ModuleUpdated extends LeadProjectState {
  final ModuleEntity module;

  const ModuleUpdated(this.module);

  @override
  List<Object?> get props => [module];
}

class ModuleDeleted extends LeadProjectState {
  final String message;

  const ModuleDeleted(this.message);

  @override
  List<Object?> get props => [message];
}

// User Assignment States
class AvailableUsersLoaded extends LeadProjectState {
  final List<AvailableUserEntity> users;

  const AvailableUsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UsersAssigned extends LeadProjectState {
  final ProjectEntity project;
  final String message;

  const UsersAssigned({required this.project, required this.message});

  @override
  List<Object?> get props => [project, message];
}

class UserRemoved extends LeadProjectState {
  final ProjectEntity project;
  final String message;

  const UserRemoved({required this.project, required this.message});

  @override
  List<Object?> get props => [project, message];
}

// Error State
class LeadProjectError extends LeadProjectState {
  final String message;

  const LeadProjectError(this.message);

  @override
  List<Object?> get props => [message];
}
