import 'package:equatable/equatable.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart';
import 'package:manage_x/features/lead/domain/entities/module_entity.dart';

abstract class UserProjectState extends Equatable {
  const UserProjectState();

  @override
  List<Object?> get props => [];
}

class UserProjectInitial extends UserProjectState {}

class UserProjectLoading extends UserProjectState {}

class MyProjectsLoaded extends UserProjectState {
  final List<ProjectEntity> projects;

  const MyProjectsLoaded(this.projects);

  @override
  List<Object?> get props => [projects];
}

class UserProjectDetailsLoaded extends UserProjectState {
  final ProjectEntity project;
  final List<ModuleEntity> modules;

  const UserProjectDetailsLoaded({
    required this.project,
    required this.modules,
  });

  @override
  List<Object?> get props => [project, modules];
}

class UserProjectError extends UserProjectState {
  final String message;

  const UserProjectError(this.message);

  @override
  List<Object?> get props => [message];
}