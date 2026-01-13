import 'package:dio/dio.dart';
import 'package:manage_x/core/networks/api_clients.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../auth/data/models/user_model.dart';
import '../models/pending_user_model.dart';

abstract class AdminRemoteDataSource {
  Future<List<PendingUserModel>> getPendingUsers();
  Future<UserModel> approveUser(String userId);
  Future<void> rejectUser(String userId, {String? reason});
  Future<List<UserModel>> getAllUsers({
    String? role,
    bool? isActive,
    String? department,
    int page = 1,
    int limit = 50,
  });
  Future<UserModel> toggleUserStatus(String userId);
  Future<void> deleteUser(String userId);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final ApiClient apiClient;

  AdminRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PendingUserModel>> getPendingUsers() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.pendingApproval);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => PendingUserModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to get pending users');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to get pending users',
      );
    }
  }

  @override
  Future<UserModel> approveUser(String userId) async {
    try {
      final response = await apiClient.dio.patch(
        ApiConstants.approveUser(userId),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to approve user');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to approve user',
      );
    }
  }

  @override
  Future<void> rejectUser(String userId, {String? reason}) async {
    try {
      final response = await apiClient.dio.patch(
        ApiConstants.rejectUser(userId),
        data: reason != null ? {'reason': reason} : null,
      );

      if (response.statusCode != 200) {
        throw ServerException('Failed to reject user');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to reject user',
      );
    }
  }

  @override
  Future<List<UserModel>> getAllUsers({
    String? role,
    bool? isActive,
    String? department,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (role != null) 'role': role,
        if (isActive != null) 'isActive': isActive,
        if (department != null) 'department': department,
      };

      final response = await apiClient.dio.get(
        ApiConstants.users,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to get users');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to get users',
      );
    }
  }

  @override
  Future<UserModel> toggleUserStatus(String userId) async {
    try {
      final response = await apiClient.dio.patch(
        ApiConstants.toggleUserStatus(userId),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to toggle user status');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to toggle user status',
      );
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      final response = await apiClient.dio.delete(
        ApiConstants.deleteUser(userId),
      );

      if (response.statusCode != 200) {
        throw ServerException('Failed to delete user');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to delete user',
      );
    }
  }
}