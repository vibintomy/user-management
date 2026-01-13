import 'package:equatable/equatable.dart';

import '../../../domain/entities/project_entity.dart';
import '../../../domain/entities/lead_entity.dart';

/// Base class for all project states
abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any action is taken
class ProjectInitial extends ProjectState {
  const ProjectInitial();
}

/// Loading state used for all async operations
class ProjectLoading extends ProjectState {
  const ProjectLoading();
}

/// Error state with a message to display
class ProjectError extends ProjectState {
  final String message;

  const ProjectError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when a list of projects has been loaded
class ProjectsLoaded extends ProjectState {
  final List<ProjectEntity> projects;

  const ProjectsLoaded({required this.projects});

  @override
  List<Object?> get props => [projects];
}

/// State when a list of available leads has been loaded
class LeadsLoaded extends ProjectState {
  final List<LeadEntity> leads;

  const LeadsLoaded({required this.leads});

  @override
  List<Object?> get props => [leads];
}

/// State when a single project has been created
class ProjectCreated extends ProjectState {
  final ProjectEntity project;

  const ProjectCreated({required this.project});

  @override
  List<Object?> get props => [project];
}

/// State when a single project has been updated
class ProjectUpdated extends ProjectState {
  final ProjectEntity project;

  const ProjectUpdated({required this.project});

  @override
  List<Object?> get props => [project];
}

/// State when a project has been deleted
class ProjectDeleted extends ProjectState {
  const ProjectDeleted();
}
