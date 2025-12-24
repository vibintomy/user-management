class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://192.168.31.229:5000/api'; // Android emulator
  // static const String baseUrl = 'http://localhost:5000/api'; // iOS simulator
  // static const String baseUrl = 'http://YOUR_IP:5000/api'; // Physical device
  
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String adminLogin = '/auth/admin/login';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String me = '/auth/me';
  static const String updateFcmToken = '/auth/fcm-token';
  
  // User Endpoints
  static const String users = '/users';
  static const String pendingApproval = '/users/pending-approval';
  static String approveUser(String id) => '/users/$id/approve';
  static String rejectUser(String id) => '/users/$id/reject';
  
  // Admin Endpoints
  static const String stats = '/admin/stats';
}