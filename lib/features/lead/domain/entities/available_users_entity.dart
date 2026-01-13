import 'package:equatable/equatable.dart';

class AvailableUserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String department;
  final String? phone;
  final bool isActive;

  const AvailableUserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    this.phone,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, name, email, department, phone, isActive];
}