import 'package:dio/dio.dart';
import 'package:manage_x/core/networks/api_clients.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
    String? fcmToken,
  });

  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
    String? department,
    String? fcmToken,
  });

  Future<AuthResponseModel> adminLogin({
    required String email,
    required String password,
  });

  Future<void> logout(String refreshToken);

  Future<void> logoutAll();

  Future<UserModel> getCurrentUser();

  Future<void> updateFcmToken(String fcmToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
          if (fcmToken != null) 'fcmToken': fcmToken,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else if (response.statusCode == 403 &&
          response.data['code'] == 'PENDING_APPROVAL') {
        throw PendingApprovalException(
          response.data['message'] ?? 'Your account is pending approval',
        );
      } else {
        throw ServerException(
          response.data['message'] ?? 'Login failed',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403 &&
          e.response?.data['code'] == 'PENDING_APPROVAL') {
        throw PendingApprovalException(
          e.response?.data['message'] ?? 'Your account is pending approval',
        );
      } else if (e.response?.statusCode == 401) {
        throw UnauthorizedException(
          e.response?.data['message'] ?? 'Invalid credentials',
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
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
    String? department,
    String? fcmToken,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          if (phone != null) 'phone': phone,
          if (department != null) 'department': department,
          if (fcmToken != null) 'fcmToken': fcmToken,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Registration failed',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ServerException(
          e.response?.data['message'] ?? 'Invalid data',
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
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthResponseModel> adminLogin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.adminLogin,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Admin login failed',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException(
          e.response?.data['message'] ?? 'Invalid admin credentials',
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
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.logout,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? 'Logout failed',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Logout failed',
      );
    }
  }

  @override
  Future<void> logoutAll() async {
    try {
      final response = await apiClient.dio.post(
        '${ApiConstants.logout}-all',
      );

      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? 'Logout from all devices failed',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Logout from all devices failed',
      );
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.me);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to get user data',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Session expired');
      } else {
        throw ServerException(
          e.response?.data['message'] ?? 'Failed to get user data',
        );
      }
    }
  }

  @override
  Future<void> updateFcmToken(String fcmToken) async {
    try {
      final response = await apiClient.dio.patch(
        ApiConstants.updateFcmToken,
        data: {'fcmToken': fcmToken},
      );

      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? 'Failed to update FCM token',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to update FCM token',
      );
    }
  }
}