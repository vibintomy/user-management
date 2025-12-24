import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? department;
  final bool isActive;
  final bool approved;
  final DateTime? approvedAt;
  final String? fcmToken;
  final DateTime? lastLogin;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.department,
    required this.isActive,
    required this.approved,
    this.approvedAt,
    this.fcmToken,
    this.lastLogin,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isAdmin => role == 'admin';
  bool get isLead => role == 'lead';
  bool get isUser => role == 'user';
  bool get isPendingApproval => !approved && !isAdmin;

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        role,
        phone,
        department,
        isActive,
        approved,
        approvedAt,
        fcmToken,
        lastLogin,
        createdAt,
        updatedAt,
      ];
}