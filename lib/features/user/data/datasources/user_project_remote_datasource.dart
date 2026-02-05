import 'package:dio/dio.dart';
import 'package:manage_x/core/constants/api_constants.dart';
import 'package:manage_x/core/errors/exceptions.dart';
import 'package:manage_x/core/networks/api_clients.dart';
import 'package:manage_x/features/admin/data/models/project_model.dart';
import 'package:manage_x/features/lead/data/models/module_model.dart';

abstract class UserProjectRemoteDataSource {
  Future<List<ProjectModel>> getMyProjects();
  Future<ProjectModel> getProject(String projectId);
  Future<List<ModuleModel>> getModulesByProject(String projectId);
  Future<ModuleModel> getModule(String moduleId);
  Future<ModuleModel> updateModuleProgress({
    required String moduleId,
    required int progress,           // expected value: 0..100
  });
}

class UserProjectRemoteDataSourceImpl implements UserProjectRemoteDataSource {
  final ApiClient apiClient;

  UserProjectRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ProjectModel>> getMyProjects() async {
    try {
      // Users see only projects they're assigned to
      final response = await apiClient.dio.get(ApiConstants.projects);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data.map((json) => ProjectModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch projects');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
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
    } catch (e) {
      throw ServerException('Unexpected error: $e');
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
    } catch (e) {
      throw ServerException('Unexpected error: $e');
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
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response?.statusCode == 401) {
      return UnauthorizedException(
        e.response?.data['message'] ?? 'Session expired',
      );
    } else if (e.response?.statusCode == 403) {
      return UnauthorizedException(
        e.response?.data['message'] ?? 'Access denied',
      );
    } else if (e.response?.statusCode == 400) {
      return ServerException(
        e.response?.data['message'] ?? 'Invalid data',
      );
    } else if (e.response?.statusCode == 404) {
      return ServerException(
        e.response?.data['message'] ?? 'Resource not found',
      );
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return NetworkException('Connection timeout');
    } else if (e.type == DioExceptionType.sendTimeout) {
      return NetworkException('Request timeout');
    } else if (e.type == DioExceptionType.unknown) {
      return NetworkException('No internet connection');
    } else {
      return ServerException(
        e.response?.data['message'] ?? 'Server error',
      );
    }
  }
    @override
  Future<ModuleModel> updateModuleProgress({
    required String moduleId,
    required int progress,
  }) async {
    try {
      final response = await apiClient.dio.patch(
        ApiConstants.updateModuleProgress(moduleId),  // ← You need to define this in ApiConstants
        data: {'progress': progress},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return ModuleModel.fromJson(data);
      } else {
        throw ServerException('Failed to update module progress');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}