import 'dart:convert';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();

  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getStoredUser();

  Future<void> cacheFcmToken(String fcmToken);
  Future<String?> getFcmToken();

  Future<bool> isLoggedIn();

  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage secureStorage;
  final LocalStorage localStorage;

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.localStorage,
  });

  @override
  Future<void> cacheAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await secureStorage.write(AppConstants.accessTokenKey, accessToken);
      await secureStorage.write(AppConstants.refreshTokenKey, refreshToken);
      await localStorage.setBool(AppConstants.isLoggedInKey, true);
    } catch (e) {
      throw CacheException('Failed to cache auth tokens');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await secureStorage.read(AppConstants.accessTokenKey);
    } catch (e) {
      throw CacheException('Failed to get access token');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await secureStorage.read(AppConstants.refreshTokenKey);
    } catch (e) {
      throw CacheException('Failed to get refresh token');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await localStorage.setString(AppConstants.userDataKey, userJson);
    } catch (e) {
      throw CacheException('Failed to cache user data');
    }
  }

  @override
  Future<UserModel?> getStoredUser() async {
    try {
      final userJson = localStorage.getString(AppConstants.userDataKey);
      if (userJson != null) {
        return UserModel.fromJson(jsonDecode(userJson));
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get stored user');
    }
  }

  @override
  Future<void> cacheFcmToken(String fcmToken) async {
    try {
      await localStorage.setString(AppConstants.fcmTokenKey, fcmToken);
    } catch (e) {
      throw CacheException('Failed to cache FCM token');
    }
  }

  @override
  Future<String?> getFcmToken() async {
    try {
      return localStorage.getString(AppConstants.fcmTokenKey);
    } catch (e) {
      throw CacheException('Failed to get FCM token');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final isLoggedIn = localStorage.getBool(AppConstants.isLoggedInKey);
      final accessToken = await getAccessToken();
      return (isLoggedIn ?? false) && accessToken != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await secureStorage.delete(AppConstants.accessTokenKey);
      await secureStorage.delete(AppConstants.refreshTokenKey);
      await localStorage.remove(AppConstants.userDataKey);
      await localStorage.remove(AppConstants.isLoggedInKey);
    } catch (e) {
      throw CacheException('Failed to clear auth data');
    }
  }
}