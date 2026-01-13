import '../../domain/entities/project_entity.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.description,
    required super.department,
    required super.assignedLeadId,
    super.assignedLeadName,
    super.assignedLeadEmail,
    required super.progress,
    required super.status,
    required super.priority,
    required super.startDate,
    required super.deadline,
    super.completedAt,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      department: json['department'] ?? '',
      assignedLeadId: json['assignedLead'] is Map
          ? json['assignedLead']['_id']
          : json['assignedLead'] ?? '',
      assignedLeadName: json['assignedLead'] is Map
          ? json['assignedLead']['name']
          : null,
      assignedLeadEmail: json['assignedLead'] is Map
          ? json['assignedLead']['email']
          : null,
      progress: json['progress'] ?? 0,
      status: json['status'] ?? 'pending',
      priority: json['priority'] ?? 'medium',
      startDate: DateTime.parse(json['startDate']),
      deadline: DateTime.parse(json['deadline']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'department': department,
      'assignedLead': assignedLeadId,
      'progress': progress,
      'status': status,
      'priority': priority,
      'startDate': startDate.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ProjectEntity toEntity() {
    return ProjectEntity(
      id: id,
      name: name,
      description: description,
      department: department,
      assignedLeadId: assignedLeadId,
      assignedLeadName: assignedLeadName,
      assignedLeadEmail: assignedLeadEmail,
      progress: progress,
      status: status,
      priority: priority,
      startDate: startDate,
      deadline: deadline,
      completedAt: completedAt,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}