import 'package:manage_x/features/lead/domain/entities/project_entitiy.dart';

class ProjectModel extends ProjectEntity {
  ProjectModel({
    required String id,
    required String name,
    required String description,
    required String department,
    required String assignedLead,
    required List<String> assignedUsers,
    required int progress,
    required String status,
    required String priority,
    required DateTime startDate,
    required DateTime deadline,
    DateTime? completedAt,
    required double totalEstimatedHours,
    required double totalActualHours,
    required String createdBy,
    required bool isActive,
    required int basePoints,
    required bool pointsDistributed,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
         id: id,
         name: name,
         description: description,
         department: department,
         assignedLead: assignedLead,
         assignedUsers: assignedUsers,
         progress: progress,
         status: status,
         priority: priority,
         startDate: startDate,
         deadline: deadline,
         completedAt: completedAt,
         totalEstimatedHours: totalEstimatedHours,
         totalActualHours: totalActualHours,
         createdBy: createdBy,
         isActive: isActive,
         basePoints: basePoints,
         pointsDistributed: pointsDistributed,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      department: json['department'] ?? '',
      assignedLead: json['assignedLead'] is String
          ? json['assignedLead']
          : json['assignedLead']?['_id'] ?? '',
      assignedUsers:
          (json['assignedUsers'] as List?)
              ?.map((e) => e is String ? e : e['_id'] as String)
              .toList() ??
          [],
      progress: json['progress'] ?? 0,
      status: json['status'] ?? 'pending',
      priority: json['priority'] ?? 'medium',
      startDate: DateTime.parse(json['startDate']),
      deadline: DateTime.parse(json['deadline']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      totalEstimatedHours: (json['totalEstimatedHours'] ?? 0).toDouble(),
      totalActualHours: (json['totalActualHours'] ?? 0).toDouble(),
      createdBy: json['createdBy'] is String
          ? json['createdBy']
          : json['createdBy']?['_id'] ?? '',
      isActive: json['isActive'] ?? true,
      basePoints: json['basePoints'] ?? 100,
      pointsDistributed: json['pointsDistributed'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'department': department,
      'assignedLead': assignedLead,
      'assignedUsers': assignedUsers,
      'progress': progress,
      'status': status,
      'priority': priority,
      'startDate': startDate.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'totalEstimatedHours': totalEstimatedHours,
      'totalActualHours': totalActualHours,
      'createdBy': createdBy,
      'isActive': isActive,
      'basePoints': basePoints,
      'pointsDistributed': pointsDistributed,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
