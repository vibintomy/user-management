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
  final String? status; // pending, in_progress, completed, blocked
  final String? priority; // low, medium, high
  final DateTime? startDate;
  final DateTime? endDate;
  final String? createdBy;
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
    this.status,
    this.priority,
    this.startDate,
    this.endDate,
     this.createdBy,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // ── ADD THIS copyWith METHOD ─────────────────────────────────────────────
  ModuleEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? project,
    List<String>? assignedUsers,
    double? estimatedTime,
    double? actualTime,
    int? progress,
    String? status,
    String? priority,
    DateTime? startDate,
    DateTime? endDate,
    String? createdBy,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ModuleEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      project: project ?? this.project,
      assignedUsers: assignedUsers ?? this.assignedUsers,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      actualTime: actualTime ?? this.actualTime,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdBy: createdBy ?? this.createdBy,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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