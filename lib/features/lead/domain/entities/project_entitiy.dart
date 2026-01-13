
import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String department;
  final String assignedLead;
  final List<String> assignedUsers;
  final int progress;
  final String status; // pending, in_progress, completed, on_hold, cancelled
  final String priority; // low, medium, high, urgent
  final DateTime startDate;
  final DateTime deadline;
  final DateTime? completedAt;
  final double totalEstimatedHours;
  final double totalActualHours;
  final String createdBy;
  final bool isActive;
  final int basePoints;
  final bool pointsDistributed;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.department,
    required this.assignedLead,
    required this.assignedUsers,
    required this.progress,
    required this.status,
    required this.priority,
    required this.startDate,
    required this.deadline,
    this.completedAt,
    required this.totalEstimatedHours,
    required this.totalActualHours,
    required this.createdBy,
    required this.isActive,
    required this.basePoints,
    required this.pointsDistributed,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        department,
        assignedLead,
        assignedUsers,
        progress,
        status,
        priority,
        startDate,
        deadline,
        completedAt,
        totalEstimatedHours,
        totalActualHours,
        createdBy,
        isActive,
        basePoints,
        pointsDistributed,
        createdAt,
        updatedAt,
      ];
}