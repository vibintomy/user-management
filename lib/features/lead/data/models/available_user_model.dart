
import 'package:manage_x/features/lead/domain/entities/available_users_entity.dart';

class AvailableUserModel extends AvailableUserEntity {
  const AvailableUserModel({
    required String id,
    required String name,
    required String email,
    required String department,
    String? phone,
    required bool isActive,
  }) : super(
          id: id,
          name: name,
          email: email,
          department: department,
          phone: phone,
          isActive: isActive,
        );

  factory AvailableUserModel.fromJson(Map<String, dynamic> json) {
    return AvailableUserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      department: json['department'] ?? '',
      phone: json['phone'],
      isActive: json['isActive'] ?? true,
    );
  }
}