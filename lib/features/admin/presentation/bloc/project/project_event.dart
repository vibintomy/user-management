import 'package:equatable/equatable.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object?> get props => [];
}

class GetAllProjectsEvent extends ProjectEvent {
  final String? status;
  final String? department;
  final String? priority;

  const GetAllProjectsEvent({
    this.status,
    this.department,
    this.priority,
  });

  @override
  List<Object?> get props => [status, department, priority];
}

class GetAvailableLeadsEvent extends ProjectEvent {
  final String department;

  const GetAvailableLeadsEvent({required this.department});

  @override
  List<Object?> get props => [department];
}

class CreateProjectEvent extends ProjectEvent {
  final String name;
  final String description;
  final String department;
  final String assignedLead;
  final DateTime deadline;
  final String priority;

  const CreateProjectEvent({
    required this.name,
    required this.description,
    required this.department,
    required this.assignedLead,
    required this.deadline,
    required this.priority,
  });

  @override
  List<Object?> get props => [
        name,
        description,
        department,
        assignedLead,
        deadline,
        priority,
      ];
}

class UpdateProjectEvent extends ProjectEvent {
  final String projectId;
  final String? name;
  final String? description;
  final String? department;
  final String? assignedLead;
  final DateTime? deadline;
  final String? priority;
  final String? status;

  const UpdateProjectEvent({
    required this.projectId,
    this.name,
    this.description,
    this.department,
    this.assignedLead,
    this.deadline,
    this.priority,
    this.status,
  });

  @override
  List<Object?> get props => [
        projectId,
        name,
        description,
        department,
        assignedLead,
        deadline,
        priority,
        status,
      ];
}

class DeleteProjectEvent extends ProjectEvent {
  final String projectId;

  const DeleteProjectEvent({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}