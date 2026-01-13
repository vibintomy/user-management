import 'package:equatable/equatable.dart';

class PendingUserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? department;
  final DateTime createdAt;

  const PendingUserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.department,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, role, phone, department, createdAt];
}