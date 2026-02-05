
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:manage_x/core/constants/api_constants.dart';
import 'package:manage_x/core/errors/exceptions.dart';
import 'package:manage_x/core/networks/api_clients.dart';
import 'package:manage_x/features/admin/data/models/project_model.dart';
import 'package:manage_x/features/lead/data/models/available_user_model.dart';
import 'package:manage_x/features/lead/data/models/module_model.dart';

abstract class LeadProjectRemoteDataSource {
  Future<List<ProjectModel>> getAllProjects();
  Future<ProjectModel> getProject(String projectId);
  Future<List<ModuleModel>> getModulesByProject(String projectId);
  Future<ModuleModel> getModule(String moduleId);
  Future<ModuleModel> createModule(String projectId, Map<String, dynamic> data);
  Future<ModuleModel> updateModule(String moduleId, Map<String, dynamic> data);
  Future<void> deleteModule(String moduleId);
  Future<ModuleModel> updateModuleProgress(String moduleId, Map<String, dynamic> data);
  Future<ProjectModel> assignUsersToProject(String projectId, List<String> userIds);
  Future<ProjectModel> removeUserFromProject(String projectId, String userId);
  Future<List<AvailableUserModel>> getAvailableUsers(String projectId);
}

class LeadProjectRemoteDataSourceImpl implements LeadProjectRemoteDataSource {
  final ApiClient apiClient;

  LeadProjectRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ProjectModel>> getAllProjects() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.projects);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data.map((json) => ProjectModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch projects');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<ProjectModel> getProject(String projectId) async {
    try {
      final response = await apiClient.dio.get(
        ApiConstants.getProjectById(projectId),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return ProjectModel.fromJson(data);
      } else {
        throw ServerException('Failed to fetch project');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<ModuleModel>> getModulesByProject(String projectId) async {
    try {
      final response = await apiClient.dio.get(
        ApiConstants.getModulesByProject(projectId),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data.map((json) => ModuleModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch modules');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<ModuleModel> getModule(String moduleId) async {
    try {
      final response = await apiClient.dio.get(
        ApiConstants.getModuleById(moduleId),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return ModuleModel.fromJson(data);
      } else {
        throw ServerException('Failed to fetch module');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<ModuleModel> createModule(String projectId, Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.createModule(projectId),
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data['data'] ?? response.data;
        return ModuleModel.fromJson(responseData);
      } else {
        throw ServerException('Failed to create module');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<ModuleModel> updateModule(String moduleId, Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.put(
        ApiConstants.updateModule(moduleId),
        data: data,
      );

      if (response.statusCode == 200) {
        final responseData = response.data['data'] ?? response.data;
        return ModuleModel.fromJson(responseData);
      } else {
        throw ServerException('Failed to update module');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> deleteModule(String moduleId) async {
    try {
      final response = await apiClient.dio.delete(
        ApiConstants.deleteModule(moduleId),
      );

      if (response.statusCode != 200) {
        throw ServerException('Failed to delete module');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<ModuleModel> updateModuleProgress(String moduleId, Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.patch(
        ApiConstants.updateModuleProgress(moduleId),
        data: data,
      );

      if (response.statusCode == 200) {
        final responseData = response.data['data'] ?? response.data;
        return ModuleModel.fromJson(responseData);
      } else {
        throw ServerException('Failed to update module progress');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<ProjectModel> assignUsersToProject(String projectId, List<String> userIds) async {
    try {
      final response = await apiClient.dio.patch(
        ApiConstants.assignUsersToProject(projectId),
        data: {'userIds': userIds},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return ProjectModel.fromJson(data);
      } else {
        throw ServerException('Failed to assign users');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<ProjectModel> removeUserFromProject(String projectId, String userId) async {
    try {
      final response = await apiClient.dio.patch(
        ApiConstants.removeUserFromProject(projectId, userId),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return ProjectModel.fromJson(data);
      } else {
        throw ServerException('Failed to remove user');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

 @override
Future<List<AvailableUserModel>> getAvailableUsers(String projectId) async {
  try {
    final response = await apiClient.dio.get(
      ApiConstants.getAvailableUsers(projectId),
    );

    if (response.statusCode == 200) {
      // Handle different response formats
      dynamic data = response.data;
      
      // If response has a 'data' wrapper
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        data = data['data'];
      }
      
      // Ensure we have a list
      if (data is! List) {
        print('⚠️ Unexpected response format: ${data.runtimeType}');
        print('Response data: $data');
        return [];
      }
      
      // Parse the list
      final List<dynamic> userList = data;
      print('✅ Found ${userList.length} available users');
      
      return userList
          .map((json) {
            try {
              if (json is Map<String, dynamic>) {
                return AvailableUserModel.fromJson(json);
              } else {
                print('⚠️ Invalid user data: ${json.runtimeType}');
                return null;
              }
            } catch (e) {
              print('❌ Error parsing user: $e');
              print('User data: $json');
              return null;
            }
          })
          .whereType<AvailableUserModel>() // Filter out nulls
          .toList();
    } else {
      throw ServerException('Failed to fetch available users');
    }
  } on DioException catch (e) {
    print('❌ DioException in getAvailableUsers: ${e.message}');
    print('Response: ${e.response?.data}');
    throw _handleDioError(e);
  } catch (e) {
    print('❌ Unexpected error in getAvailableUsers: $e');
    throw ServerException('Unexpected error: $e');
  }
}

  Exception _handleDioError(DioException e) {
    if (e.response?.statusCode == 401) {
      return UnauthorizedException('Session expired');
    } else if (e.response?.statusCode == 403) {
      return UnauthorizedException('Access denied');
    } else if (e.response?.statusCode == 400) {
      return ServerException(e.response?.data['message'] ?? 'Invalid data');
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return NetworkException('Connection timeout');
    } else if (e.type == DioExceptionType.unknown) {
      return NetworkException('No internet connection');
    } else {
      return ServerException(e.response?.data['message'] ?? 'Server error');
    }
  }
}