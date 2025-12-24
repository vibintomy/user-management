import 'dart:convert';
import 'package:manage_x/features/auth/domain/entities/auth_response_entities.dart';

import 'user_model.dart';

class AuthResponseModel extends AuthResponseEntity {
  const AuthResponseModel({
    required super.success,
    required super.message,
    required super.accessToken,
    required super.refreshToken,
    required super.user,
  });

  // From JSON
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
     final userData = json['data'] ?? json['user'] ?? {};
  
  // For admin, add default values for missing fields
  if (userData['role'] == 'admin') {
    userData['name'] = userData['name'] ?? 'Administrator';
    userData['isActive'] = userData['isActive'] ?? true;
    userData['approved'] = userData['approved'] ?? true;
    userData['createdAt'] = userData['createdAt'] ?? DateTime.now().toIso8601String();
    userData['updatedAt'] = userData['updatedAt'] ?? DateTime.now().toIso8601String();
  }
    return AuthResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      accessToken: json['accessToken'] ?? json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      user: UserModel.fromJson(userData),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'data': (user as UserModel).toJson(),
    };
  }

  // To Entity
  AuthResponseEntity toEntity() {
    return AuthResponseEntity(
      success: success,
      message: message,
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user,
    );
  }

  // To JSON String
  String toJsonString() => jsonEncode(toJson());

  // From JSON String
  factory AuthResponseModel.fromJsonString(String jsonString) {
    return AuthResponseModel.fromJson(jsonDecode(jsonString));
  }
}