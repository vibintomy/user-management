import '../../domain/entities/lead_entity.dart';

class LeadModel extends LeadEntity {
  const LeadModel({
    required super.id,
    required super.name,
    required super.email,
    required super.department,
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      department: json['department'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'department': department,
    };
  }

  LeadEntity toEntity() {
    return LeadEntity(
      id: id,
      name: name,
      email: email,
      department: department,
    );
  }
}