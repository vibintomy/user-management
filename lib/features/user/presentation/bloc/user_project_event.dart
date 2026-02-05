import 'package:equatable/equatable.dart';

abstract class UserProjectEvent extends Equatable {
  const UserProjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyProjectsEvent extends UserProjectEvent {}

class LoadUserProjectDetailsEvent extends UserProjectEvent {
  final String projectId;

  const LoadUserProjectDetailsEvent(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class RefreshUserProjectsEvent extends UserProjectEvent {}

class RefreshUserProjectDetailsEvent extends UserProjectEvent {
  final String projectId;

  const RefreshUserProjectDetailsEvent(this.projectId);

  @override
  List<Object?> get props => [projectId];
}
class UpdateModuleProgressEvent extends UserProjectEvent {
  final String moduleId;
  final int newProgress;

  const UpdateModuleProgressEvent({
    required this.moduleId,
    required this.newProgress,
  });
}