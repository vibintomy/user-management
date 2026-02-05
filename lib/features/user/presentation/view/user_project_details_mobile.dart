import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart';
import 'package:manage_x/features/bottom_navigation/users_bottom_navigation/user_bottom_navigation.dart';
import 'package:manage_x/features/lead/domain/entities/module_entity.dart';
import 'package:manage_x/features/user/presentation/bloc/user_project_bloc.dart';
import 'package:manage_x/features/user/presentation/bloc/user_project_event.dart';
import 'package:manage_x/features/user/presentation/bloc/user_project_state.dart';
import 'package:manage_x/features/user/presentation/pages/user_homescreen.dart';

class UserProjectDetailsScreenMobile extends StatefulWidget {
  final String projectId;
  final String currentUserId;

  const UserProjectDetailsScreenMobile({
    super.key,
    required this.projectId,
    required this.currentUserId,
  });

  @override
  State<UserProjectDetailsScreenMobile> createState() =>
      _UserProjectDetailsScreenState();
}

class _UserProjectDetailsScreenState extends State<UserProjectDetailsScreenMobile> {
  @override
  void initState() {
    super.initState();
    context.read<UserProjectBloc>().add(
      LoadUserProjectDetailsEvent(widget.projectId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<UserProjectBloc, UserProjectState>(
        listener: (context, state) {
          if (state is UserProjectError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is UserProjectLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserProjectDetailsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<UserProjectBloc>().add(
                  RefreshUserProjectDetailsEvent(widget.projectId),
                );
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProjectHeader(state.project),
                    const Divider(height: 32),
                    _buildModulesSection(context, state.modules),
                    kheight20,
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserBottomNavigation()));
                        },
                        child: Text('Done'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  // ── Project Header ────────────────────────────────────────────────────────
  Widget _buildProjectHeader(ProjectEntity project) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.15),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  project.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildPriorityBadge(project.priority),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            project.description ?? 'No description available',
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),
          _buildStatusChip(project.status),
          const SizedBox(height: 20),
          _buildProgressBar(project.progress),
          const SizedBox(height: 20),
          _buildDeadlineInfo(project.deadline),
        ],
      ),
    );
  }

  // ── Modules Section ───────────────────────────────────────────────────────
  Widget _buildModulesSection(
    BuildContext context,
    List<ModuleEntity> modules,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Text(
            'My Tasks',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        if (modules.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.widgets_outlined,
                    size: 70,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No tasks assigned yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          )
        else
          ...modules
              .map((module) => _buildModuleCard(context, module))
              .toList(),
      ],
    );
  }

  // ── Module Card ───────────────────────────────────────────────────────────
  Widget _buildModuleCard(BuildContext context, ModuleEntity module) {
    final isAssignedToMe = module.assignedUsers.contains(widget.currentUserId);
    final progressColor = _getModuleProgressColor(module.progress);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Priority
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    module.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            if (module.description?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              Text(
                module.description!,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],

            const SizedBox(height: 16),

            // Status + Estimated time
            Row(
              children: [
                Chip(
                  label: Text(module.status ?? 'Unknown'),
                  backgroundColor: Colors.blue.shade50,
                  labelStyle: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.timer_outlined, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 6),
                Text(
                  '${module.estimatedTime.toStringAsFixed(1)}h estimated',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Progress Section Title
            Text(
              isAssignedToMe ? 'Your Progress' : 'Task Progress',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),

            // Progress Bar (always visible - read only style)
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: module.progress / 100,
                      minHeight: 12,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${module.progress}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: progressColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Edit controls ── only for assigned user ───────────────────────
            if (isAssignedToMe) ...[
              Text(
                'Update Progress',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),

              // Slider
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 10,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 14,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 28,
                  ),
                ),
                child: Slider(
                  value: module.progress.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 20,
                  label: '${module.progress.round()}%',
                  activeColor: progressColor,
                  inactiveColor: Colors.grey[300],
                  onChangeEnd: (value) {
                    final newProgress = value.round();
                    if (newProgress != module.progress) {
                      _showUpdateConfirmation(context, module, newProgress);
                    }
                  },
                  onChanged: (double value) {},
                ),
              ),

              const SizedBox(height: 16),

              // Quick buttons
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildQuickProgressButton(context, module, 25),
                  _buildQuickProgressButton(context, module, 50),
                  _buildQuickProgressButton(context, module, 75),
                  _buildQuickProgressButton(
                    context,
                    module,
                    100,
                    label: 'Complete',
                  ),
                ],
              ),
            ] else ...[
              // Hint for other users
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You are not assigned to this task',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Dates
            if (module.startDate != null || module.endDate != null)
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    _formatDateRange(module.startDate, module.endDate),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // ── Progress Update Confirmation ──────────────────────────────────────────
  void _showUpdateConfirmation(
    BuildContext context,
    ModuleEntity module,
    int newProgress,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Update Progress'),
        content: Text('Set this task progress to $newProgress%?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<UserProjectBloc>().add(
                UpdateModuleProgressEvent(
                  moduleId: module.id,
                  newProgress: newProgress,
                ),
              );
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  context.read<UserProjectBloc>().add(
                    RefreshUserProjectDetailsEvent(widget.projectId),
                  );
                }
              });
            },
            child: Text(
              'Update',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Color _getModuleProgressColor(int progress) {
    if (progress < 30) return Colors.red;
    if (progress < 70) return Colors.orange;
    return Colors.green;
  }

  Widget _buildQuickProgressButton(
    BuildContext context,
    ModuleEntity module,
    int value, {
    String? label,
  }) {
    final color = _getModuleProgressColor(value);

    return OutlinedButton(
      onPressed: () => _showUpdateConfirmation(context, module, value),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label ?? '+$value%'),
    );
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null && end == null) return '';
    final startStr = start != null ? DateFormat('MMM dd').format(start) : '';
    final endStr = end != null ? DateFormat('MMM dd').format(end) : '';

    if (startStr.isNotEmpty && endStr.isNotEmpty) return '$startStr → $endStr';
    if (startStr.isNotEmpty) return 'Starts $startStr';
    return 'Due $endStr';
  }

  Widget _buildPriorityBadge(String priority) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'urgent':
        color = Colors.red;
        break;
      case 'high':
        color = Colors.orange;
        break;
      case 'medium':
        color = Colors.blue;
        break;
      default:
        color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'in_progress':
        color = Colors.blue;
        icon = Icons.play_circle;
        break;
      case 'on_hold':
        color = Colors.orange;
        icon = Icons.pause_circle;
        break;
      case 'cancelled':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        icon = Icons.pending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            status.replaceAll('_', ' ').toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int progress) {
    final color = progress < 30
        ? Colors.red
        : progress < 70
        ? Colors.orange
        : Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Overall Progress',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '$progress%',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress / 100,
            minHeight: 10,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildDeadlineInfo(DateTime deadline) {
    final isOverdue = DateTime.now().isAfter(deadline);
    final daysRemaining = deadline.difference(DateTime.now()).inDays;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOverdue ? Colors.red.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOverdue ? Colors.red.shade200 : Colors.blue.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isOverdue ? Icons.warning : Icons.calendar_today,
            size: 20,
            color: isOverdue ? Colors.red : Colors.blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOverdue ? 'OVERDUE' : 'DEADLINE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isOverdue ? Colors.red : Colors.blue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('MMM dd, yyyy').format(deadline),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isOverdue
                        ? Colors.red.shade700
                        : Colors.blue.shade700,
                  ),
                ),
                if (isOverdue)
                  Text(
                    '${daysRemaining.abs()} days overdue',
                    style: TextStyle(fontSize: 11, color: Colors.red.shade600),
                  )
                else
                  Text(
                    '$daysRemaining days remaining',
                    style: TextStyle(fontSize: 11, color: Colors.blue.shade600),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
