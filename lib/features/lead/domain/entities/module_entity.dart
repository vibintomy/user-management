import 'package:equatable/equatable.dart';

class ModuleEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String project;
  final List<String> assignedUsers;
  final double estimatedTime;
  final double actualTime;
  final int progress;
  final String status; // pending, in_progress, completed, blocked
  final String priority; // low, medium, high
  final DateTime? startDate;
  final DateTime? endDate;
  final String createdBy;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ModuleEntity({
    required this.id,
    required this.name,
    this.description,
    required this.project,
    required this.assignedUsers,
    required this.estimatedTime,
    required this.actualTime,
    required this.progress,
    required this.status,
    required this.priority,
    this.startDate,
    this.endDate,
    required this.createdBy,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        project,
        assignedUsers,
        estimatedTime,
        actualTime,
        progress,
        status,
        priority,
        startDate,
        endDate,
        createdBy,
        notes,
        createdAt,
        updatedAt,
      ];
}
