import 'dart:convert';

import 'package:manage_x/features/auth/domain/entities/user_entities.dart';


class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.phone,
    super.department,
    required super.isActive,
    required super.approved,
    super.approvedAt,
    super.fcmToken,
    super.lastLogin,
    required super.createdAt,
    required super.updatedAt,
  });

  // From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? 'Admin',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      phone: json['phone'],
      department: json['department'],
      isActive: json['isActive'] ?? true,
      approved: json['approved'] ?? true,
      approvedAt: json['approvedAt'] != null
          ? DateTime.parse(json['approvedAt'])
          : null,
      fcmToken: json['fcmToken'],
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'department': department,
      'isActive': isActive,
      'approved': approved,
      'approvedAt': approvedAt?.toIso8601String(),
      'fcmToken': fcmToken,
      'lastLogin': lastLogin?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // To Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      role: role,
      phone: phone,
      department: department,
      isActive: isActive,
      approved: approved,
      approvedAt: approvedAt,
      fcmToken: fcmToken,
      lastLogin: lastLogin,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // From Entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      role: entity.role,
      phone: entity.phone,
      department: entity.department,
      isActive: entity.isActive,
      approved: entity.approved,
      approvedAt: entity.approvedAt,
      fcmToken: entity.fcmToken,
      lastLogin: entity.lastLogin,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // To JSON String
  String toJsonString() => jsonEncode(toJson());

  // From JSON String
  factory UserModel.fromJsonString(String jsonString) {
    return UserModel.fromJson(jsonDecode(jsonString));
  }

  // CopyWith
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? phone,
    String? department,
    bool? isActive,
    bool? approved,
    DateTime? approvedAt,
    String? fcmToken,
    DateTime? lastLogin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      isActive: isActive ?? this.isActive,
      approved: approved ?? this.approved,
      approvedAt: approvedAt ?? this.approvedAt,
      fcmToken: fcmToken ?? this.fcmToken,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}