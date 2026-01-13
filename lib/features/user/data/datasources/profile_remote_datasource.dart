import 'package:dio/dio.dart';
import 'package:manage_x/core/constants/api_constants.dart';
import 'package:manage_x/core/errors/exceptions.dart';
import 'package:manage_x/core/networks/api_clients.dart';
import 'package:manage_x/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:manage_x/features/auth/data/models/user_model.dart';
abstract class ProfileRemoteDataSource {
  Future<UserModel> updateProfile({
    String? name,
    String? password,
    String? phone,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;
  final AuthLocalDataSource localDataSource;

  ProfileRemoteDataSourceImpl({
    required this.apiClient,
    required this.localDataSource,
  });

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? password,
    String? phone,
  }) async {
    try {
      // Get current user ID from local storage
      final cachedUser = await localDataSource.getStoredUser();
      if (cachedUser == null) {
        throw UnauthorizedException('User not found');
      }

      final userId = cachedUser.id;

      // Build the update data
      final Map<String, dynamic> updateData = {};
      if (name != null && name.isNotEmpty) updateData['name'] = name;
      if (password != null && password.isNotEmpty) updateData['password'] = password;
      if (phone != null && phone.isNotEmpty) updateData['phone'] = phone;

      if (updateData.isEmpty) {
        throw ServerException('No data to update');
      }

      // Make PUT request to /user/:id
      final response = await apiClient.dio.put(
        ApiConstants.updateUserById(userId),
        data: updateData,
      );

      if (response.statusCode == 200) {
        // Check if response has 'data' field or is direct user object
        if (response.data['data'] != null) {
          return UserModel.fromJson(response.data['data']);
        } else {
          return UserModel.fromJson(response.data);
        }
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to update profile',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Session expired');
      } else if (e.response?.statusCode == 400) {
        throw ServerException(
          e.response?.data['message'] ?? 'Invalid data',
        );
      } else if (e.response?.statusCode == 403) {
        throw UnauthorizedException(
          e.response?.data['message'] ?? 'Access denied',
        );
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.unknown) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException(
          e.response?.data['message'] ?? 'Server error',
        );
      }
    } catch (e) {
      if (e is UnauthorizedException || e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(e.toString());
    }
  }
}
