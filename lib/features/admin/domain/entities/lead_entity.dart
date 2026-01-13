import 'package:equatable/equatable.dart';

class LeadEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String department;

  const LeadEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
  });

  @override
  List<Object?> get props => [id, name, email, department];
}