class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://user-management-x.onrender.com/api'; // Android emulator
  // 192.168.1.105
  // 192.168.70.86:5000
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
  static String updateUserById(String id) => '/users/$id';

  // Admin Endpoints
  static const String stats = '/admin/stats';
  static String toggleUserStatus(String id) => '/users/$id/toggle-status';
  static String deleteUser(String id) => '/users/$id';

  // Project endpoints
  static const String projects = '/project'; // GET all projects
  static String getProjectById(String id) => '/project/$id'; // GET single project
  static String updateProject(String id) => '/project/$id'; // PUT
  static String deleteProject(String id) => '/project/$id'; // DELETE
  static String assignUsersToProject(String id) => '/project/$id/assign-users'; // PATCH
  static String removeUserFromProject(String projectId, String userId) => 
      '/project/$projectId/remove-user/$userId'; // PATCH
  static String getAvailableUsers(String id) => '/project/$id/available-users'; // GET
  static String getAvailableLeads(String department) => 
      '/project/available-leads/$department'; // GET

  // Module endpoints
  static String createModule(String projectId) => '/module/projects/$projectId/modules'; // POST
  static String getModulesByProject(String projectId) => '/module/projects/$projectId/modules'; // GET
  static String getModuleById(String id) => '/module/$id'; // GET
  static String updateModule(String id) => '/module/$id'; // PUT
  static String deleteModule(String id) => '/module/$id'; // DELETE
  static String updateModuleProgress(String id) => '/module/$id/progress'; // PATCH
}
