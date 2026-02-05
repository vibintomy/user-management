class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://user-management-x.onrender.com/api'; // Android emulator

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
  static const String projects = '/projects'; // GET all projects
  static String getProjectById(String id) => '/projects/$id'; // GET single project
  static String updateProject(String id) => '/projects/$id'; // PUT
  static String deleteProject(String id) => '/projects/$id'; // DELETE
  static String assignUsersToProject(String id) => '/projects/$id/assign-users'; // PATCH
  static String removeUserFromProject(String projectId, String userId) => 
      '/projects/$projectId/remove-user/$userId'; // PATCH
  static String getAvailableUsers(String id) => '/projects/$id/available-users'; // GET
static String getAvailableLeads(String department) =>
  '/projects/available-leads/${Uri.encodeComponent(department)}';


// Module endpoints
static const String modules = '/modules';

static String createModule(String projectId) =>
    '/modules/projects/$projectId/modules'; // POST

static String getModulesByProject(String projectId) =>
    '/modules/projects/$projectId/modules'; // GET

static String getModuleById(String id) =>
    '/modules/$id'; // GET

static String updateModule(String id) =>
    '/modules/$id'; // PUT

static String deleteModule(String id) =>
    '/modules/$id'; // DELETE

static String updateModuleProgress(String id) =>
    '/modules/$id/progress'; // PATCH

}