import 'package:equatable/equatable.dart';

abstract class LeadProjectEvent extends Equatable {
  const LeadProjectEvent();

  @override
  List<Object?> get props => [];
}

// Project Events
class LoadProjectsEvent extends LeadProjectEvent {}

class LoadProjectDetailsEvent extends LeadProjectEvent {
  final String projectId;

  const LoadProjectDetailsEvent(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

// Module Events
class LoadModulesEvent extends LeadProjectEvent {
  final String projectId;

  const LoadModulesEvent(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class CreateModuleEvent extends LeadProjectEvent {
  final String projectId;
  final String name;
  final String? description;
  final double estimatedTime;
  final String priority;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? notes;

  const CreateModuleEvent({
    required this.projectId,
    required this.name,
    this.description,
    required this.estimatedTime,
    required this.priority,
    this.startDate,
    this.endDate,
    this.notes,
  });

  @override
  List<Object?> get props => [
        projectId,
        name,
        description,
        estimatedTime,
        priority,
        startDate,
        endDate,
        notes,
      ];
}

class UpdateModuleEvent extends LeadProjectEvent {
  final String moduleId;
  final String? name;
  final String? description;
  final double? estimatedTime;
  final String? priority;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? notes;

  const UpdateModuleEvent({
    required this.moduleId,
    this.name,
    this.description,
    this.estimatedTime,
    this.priority,
    this.status,
    this.startDate,
    this.endDate,
    this.notes,
  });

  @override
  List<Object?> get props => [
        moduleId,
        name,
        description,
        estimatedTime,
        priority,
        status,
        startDate,
        endDate,
        notes,
      ];
}

class DeleteModuleEvent extends LeadProjectEvent {
  final String moduleId;
  final String projectId;

  const DeleteModuleEvent({
    required this.moduleId,
    required this.projectId,
  });

  @override
  List<Object?> get props => [moduleId, projectId];
}

class UpdateModuleProgressEvent extends LeadProjectEvent {
  final String moduleId;
  final int progress;
  final double? actualTime;

  const UpdateModuleProgressEvent({
    required this.moduleId,
    required this.progress,
    this.actualTime,
  });

  @override
  List<Object?> get props => [moduleId, progress, actualTime];
}

// User Assignment Events
class LoadAvailableUsersEvent extends LeadProjectEvent {
  final String projectId;

  const LoadAvailableUsersEvent(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class AssignUsersEvent extends LeadProjectEvent {
  final String projectId;
  final List<String> userIds;

  const AssignUsersEvent({
    required this.projectId,
    required this.userIds,
  });

  @override
  List<Object?> get props => [projectId, userIds];
}

class RemoveUserEvent extends LeadProjectEvent {
  final String projectId;
  final String userId;

  const RemoveUserEvent({
    required this.projectId,
    required this.userId,
  });

  @override
  List<Object?> get props => [projectId, userId];
}