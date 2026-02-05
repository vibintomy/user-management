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
    String? status,           // ← changed to nullable
    String? priority,         // ← changed to nullable
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
          status: status ?? 'pending',      // ← fallback when null
          priority: priority ?? 'medium',   // ← fallback when null
          startDate: startDate,
          endDate: endDate,
          createdBy: createdBy,
          notes: notes,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unnamed Module',
      description: json['description']?.toString(),
      project: json['project'] is String
          ? json['project']
          : json['project']?['_id']?.toString() ?? '',
      assignedUsers: (json['assignedUsers'] as List<dynamic>?)
              ?.map((e) => (e is Map ? e['_id']?.toString() : e?.toString()) ?? '')
              .where((id) => id.isNotEmpty)
              .toList() ??
          [],
      estimatedTime: (json['estimatedTime'] as num?)?.toDouble() ?? 0.0,
      actualTime: (json['actualTime'] as num?)?.toDouble() ?? 0.0,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString(),           // can be null now
      priority: json['priority']?.toString(),       // can be null now
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'].toString())
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'].toString())
          : null,
      createdBy: json['createdBy'] is String
          ? json['createdBy']
          : json['createdBy']?['_id']?.toString() ?? '',
      notes: json['notes']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
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