import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/custom_button.dart';
import 'package:manage_x/core/widgets/snackbar.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/core/widgets/typography/body_text.dart';
import 'package:manage_x/core/widgets/typography/page_title.dart';
import 'package:manage_x/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:manage_x/features/admin/presentation/bloc/admin_event.dart';
import 'package:manage_x/features/admin/presentation/bloc/admin_state.dart';
import 'package:manage_x/features/auth/domain/entities/user_entities.dart';

class UserRequestScreenMobile extends StatefulWidget {
  const UserRequestScreenMobile({super.key});

  @override
  State<UserRequestScreenMobile> createState() => _UserRequestScreenMobileState();
}

class _UserRequestScreenMobileState extends State<UserRequestScreenMobile>
    with TickerProviderStateMixin {
  late TabController _primaryTabController;

  @override
  void initState() {
    super.initState();
    _primaryTabController = TabController(length: 2, vsync: this);
    _primaryTabController.addListener(_handleTabChange);

   WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<AdminBloc>().add(GetPendingUsersEvent());  
    context.read<AdminBloc>().add(const GetAllUsersEvent()); 
  });
  }

  void _handleTabChange() {
    if (_primaryTabController.index == 0) {
      // When switching to "Users" tab → load all users
      context.read<AdminBloc>().add(const GetAllUsersEvent());
    } else if (_primaryTabController.index == 1) {
      // When switching to "Request" tab → load pending
      context.read<AdminBloc>().add(GetPendingUsersEvent());
    }
  }

  @override
  void dispose() {
    _primaryTabController.removeListener(_handleTabChange);
    _primaryTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppPageTitle("Users", AppColors.black),
        centerTitle: true,
        bottom: TabBar(
          controller: _primaryTabController,
          tabs: const [
            Tab(text: 'Users'),
            Tab(text: 'Request'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _primaryTabController,
        children: [
          // First tab: Requests (with secondary tabs)
          Padding(
            padding: EdgeInsets.all(16.0),
            child: BlocBuilder<AdminBloc, AdminState>(
              builder: (context, state) {
                if (state is AdminLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is UsersListLoaded) {
                  if (state.users.isEmpty) {
                    return const Center(child: Text('No users found'));
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return _ActiveUserCard(user: user);
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          // Second tab: Approved Users → Show your card(s) here
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocConsumer<AdminBloc, AdminState>(
              listener: (context, state) {
                if (state is UserApproved) {
                  showAwesomeSnackBar(
                    title: "User Approved",
                    message: "User Approved Successfully",
                    contentType: ContentType.success,
                  );
                  context.read<AdminBloc>().add(GetPendingUsersEvent());
                } else if (state is UserRejected) {
                  showAwesomeSnackBar(
                    title: "User Rejected",
                    message: "User Rejected Successfully",
                    contentType: ContentType.failure,
                  );
                  context.read<AdminBloc>().add(GetPendingUsersEvent());
                } else if (state is AdminError) {
                  showAwesomeSnackBar(
                    title: "Error",
                    message: state.message,
                    contentType: ContentType.failure,
                  );
                }
              },
              builder: (context, state) {
                if (state is AdminLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is PendingUsersLoaded) {
                  if (state.users.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.green,
                            size: 100,
                          ),
                          kheight10,
                          AppBodyText("No pending requests"),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<AdminBloc>().add(GetPendingUsersEvent());
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        return _PendingUserCard(
                          user: user,
                          onApprove: () {
                            _showApproveDialog(context, user.id, user.name);
                          },
                          onReject: () {
                            _showRejectDialog(context, user.id, user.name);
                          },
                        );
                      },
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showApproveDialog(BuildContext context, String userId, String userName) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Approve User'),
      content: Text('Are you sure you want to approve $userName?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<AdminBloc>().add(ApproveUserEvent(userId: userId));
            Navigator.pop(dialogContext);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text('Approve'),
        ),
      ],
    ),
  );
}

void _showRejectDialog(BuildContext context, String userId, String userName) {
  final reasonController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Reject User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Are you sure you want to reject $userName?'),
          const SizedBox(height: 16),
          TextField(
            controller: reasonController,
            decoration: const InputDecoration(
              labelText: 'Reason (optional)',
              hintText: 'Enter rejection reason',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<AdminBloc>().add(
              RejectUserEvent(
                userId: userId,
                reason: reasonController.text.trim().isEmpty
                    ? null
                    : reasonController.text.trim(),
              ),
            );
            Navigator.pop(dialogContext);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Reject'),
        ),
      ],
    ),
  );
}

class _PendingUserCard extends StatelessWidget {
  final dynamic user;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _PendingUserCard({
    required this.user,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: user.role == 'lead'
                        ? Colors.purple.shade100
                        : Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user.role.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: user.role == 'lead'
                          ? Colors.purple.shade700
                          : Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (user.phone != null) ...[
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    user.phone!,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (user.department != null) ...[
              Row(
                children: [
                  Icon(Icons.business, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    user.department!,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  'Requested: ${DateFormat('MMM dd, yyyy').format(user.createdAt)}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.close),
                    label: const Text('Reject'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.check),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class _ActiveUserCard extends StatelessWidget {
  final UserEntity user;

  const _ActiveUserCard({required this.user});

  void _showDeleteDialog(BuildContext context, String userId, String userName) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete $userName permanently?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AdminBloc>().add(DeleteUserEvent(userId: userId));
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child: Text(
                user.name[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  if (user.department != null)
                    Text(
                      user.department!,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  if (user.phone != null)
                    Text(
                      user.phone!,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                ],
              ),
            ),
            // Role badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: user.role == 'lead' ? Colors.purple.shade100 : Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                user.role.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: user.role == 'lead' ? Colors.purple.shade700 : Colors.blue.shade700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Three dots menu
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteDialog(context, user.id, user.name);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete User', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}