import '../../domain/entities/pending_user_entity.dart';

class PendingUserModel extends PendingUserEntity {
  const PendingUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.phone,
    super.department,
    required super.createdAt,
  });

  factory PendingUserModel.fromJson(Map<String, dynamic> json) {
    return PendingUserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      phone: json['phone'],
      department: json['department'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'department': department,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  PendingUserEntity toEntity() {
    return PendingUserEntity(
      id: id,
      name: name,
      email: email,
      role: role,
      phone: phone,
      department: department,
      createdAt: createdAt,
    );
  }
}