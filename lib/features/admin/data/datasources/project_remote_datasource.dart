import 'package:dio/dio.dart';
import 'package:manage_x/core/networks/api_clients.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/project_model.dart';
import '../models/lead_model.dart';

abstract class ProjectRemoteDataSource {
  Future<ProjectModel> createProject({
    required String name,
    required String description,
    required String department,
    required String assignedLead,
    required DateTime deadline,
    String priority = 'medium',
  });

  Future<List<ProjectModel>> getAllProjects({
    String? status,
    String? department,
    String? priority,
    int page = 1,
    int limit = 50,
  });

  Future<List<LeadModel>> getAvailableLeads(String department);

  Future<ProjectModel> getProject(String projectId);

  Future<ProjectModel> updateProject({
    required String projectId,
    String? name,
    String? description,
    String? department,
    String? assignedLead,
    DateTime? deadline,
    String? priority,
    String? status,
  });

  Future<void> deleteProject(String projectId);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final ApiClient apiClient;

  ProjectRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProjectModel> createProject({
    required String name,
    required String description,
    required String department,
    required String assignedLead,
    required DateTime deadline,
    String priority = 'medium',
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.projects,
        data: {
          'name': name,
          'description': description,
          'department': department,
          'assignedLead': assignedLead,
          'deadline': deadline.toIso8601String(),
          'priority': priority,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ProjectModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to create project');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to create project',
      );
    }
  }

  @override
  Future<List<ProjectModel>> getAllProjects({
    String? status,
    String? department,
    String? priority,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
        if (department != null) 'department': department,
        if (priority != null) 'priority': priority,
      };

      final response = await apiClient.dio.get(
        ApiConstants.projects,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ProjectModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to get projects');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to get projects',
      );
    }
  }

  @override
  Future<List<LeadModel>> getAvailableLeads(String department) async {
    try {
      final response = await apiClient.dio.get(
        ApiConstants.getAvailableLeads(department),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => LeadModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to get available leads');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to get available leads',
      );
    }
  }

  @override
  Future<ProjectModel> getProject(String projectId) async {
    try {
      final response = await apiClient.dio.get(
        ApiConstants.getProjectById(projectId),
      );

      if (response.statusCode == 200) {
        return ProjectModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to get project');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to get project',
      );
    }
  }

  @override
  Future<ProjectModel> updateProject({
    required String projectId,
    String? name,
    String? description,
    String? department,
    String? assignedLead,
    DateTime? deadline,
    String? priority,
    String? status,
  }) async {
    try {
      final response = await apiClient.dio.put(
        ApiConstants.updateProject(projectId),
        data: {
          if (name != null) 'name': name,
          if (description != null) 'description': description,
          if (department != null) 'department': department,
          if (assignedLead != null) 'assignedLead': assignedLead,
          if (deadline != null) 'deadline': deadline.toIso8601String(),
          if (priority != null) 'priority': priority,
          if (status != null) 'status': status,
        },
      );

      if (response.statusCode == 200) {
        return ProjectModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to update project');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to update project',
      );
    }
  }

  @override
  Future<void> deleteProject(String projectId) async {
    try {
      final response = await apiClient.dio.delete(
        ApiConstants.deleteProject(projectId),
      );

      if (response.statusCode != 200) {
        throw ServerException('Failed to delete project');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to delete project',
      );
    }
  }
}