import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String department;
  final String assignedLeadId;
  final String? assignedLeadName;
  final String? assignedLeadEmail;
  final int progress;
  final String status;
  final String priority;
  final DateTime startDate;
  final DateTime deadline;
  final DateTime? completedAt;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.department,
    required this.assignedLeadId,
    this.assignedLeadName,
    this.assignedLeadEmail,
    required this.progress,
    required this.status,
    required this.priority,
    required this.startDate,
    required this.deadline,
    this.completedAt,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        department,
        assignedLeadId,
        progress,
        status,
        priority,
        startDate,
        deadline,
        completedAt,
        isActive,
        createdAt,
        updatedAt,
      ];
}