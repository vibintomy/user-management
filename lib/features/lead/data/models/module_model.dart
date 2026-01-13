
import 'package:manage_x/features/lead/domain/entities/module_entity.dart';

class ModuleModel extends ModuleEntity {
  const ModuleModel({
    required String id,
    required String name,
    String? description,
    required String project,
    required List<String> assignedUsers,
    required double estimatedTime,
    required double actualTime,
    required int progress,
    required String status,
    required String priority,
    DateTime? startDate,
    DateTime? endDate,
    required String createdBy,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          name: name,
          description: description,
          project: project,
          assignedUsers: assignedUsers,
          estimatedTime: estimatedTime,
          actualTime: actualTime,
          progress: progress,
          status: status,
          priority: priority,
          startDate: startDate,
          endDate: endDate,
          createdBy: createdBy,
          notes: notes,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      project: json['project'] is String
          ? json['project']
          : json['project']?['_id'] ?? '',
      assignedUsers: (json['assignedUsers'] as List?)
              ?.map((e) => e is String ? e : e['_id'] as String)
              .toList() ??
          [],
      estimatedTime: (json['estimatedTime'] ?? 0).toDouble(),
      actualTime: (json['actualTime'] ?? 0).toDouble(),
      progress: json['progress'] ?? 0,
      status: json['status'] ?? 'pending',
      priority: json['priority'] ?? 'medium',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      createdBy: json['createdBy'] is String
          ? json['createdBy']
          : json['createdBy']?['_id'] ?? '',
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'project': project,
      'assignedUsers': assignedUsers,
      'estimatedTime': estimatedTime,
      'actualTime': actualTime,
      'progress': progress,
      'status': status,
      'priority': priority,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'notes': notes,
    };
  }
}