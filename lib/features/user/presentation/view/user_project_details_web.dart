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

class UserProjectDetailsWeb extends StatefulWidget {
  final String projectId;
  final String currentUserId;

  const UserProjectDetailsWeb({
    super.key,
    required this.projectId,
    required this.currentUserId,
  });

  @override
  State<UserProjectDetailsWeb> createState() => _UserProjectDetailsWebState();
}

class _UserProjectDetailsWebState extends State<UserProjectDetailsWeb> {
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
                await Future.delayed(const Duration(milliseconds: 600));
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isVeryWide = constraints.maxWidth > 1200;
                  final contentWidth = isVeryWide ? 1100.0 : constraints.maxWidth;

                  return SingleChildScrollView(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: contentWidth),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Project header (full width)
                              _buildProjectHeader(state.project),
                              const SizedBox(height: 32),

                              // Main content: modules list + optional sidebar
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Main modules section (takes most space)
                                  Expanded(
                                    flex: 7,
                                    child: _buildModulesSection(
                                      context,
                                      state.modules,
                                    ),
                                  ),

                                  if (isVeryWide) ...[
                                    const SizedBox(width: 40),
                                    // Optional narrow sidebar (you can put stats, quick actions, team, etc. here later)
                                    Expanded(
                                      flex: 3,
                                      child: _buildWebSidebar(state.project),
                                    ),
                                  ],
                                ],
                              ),

                              const SizedBox(height: 48),

                              // Done button – centered or aligned
                              Center(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.check_circle_outline),
                                  label: const Text('Done – Back to Dashboard'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    textStyle: const TextStyle(fontSize: 16),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const UserBottomNavigation(),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  // ── Project Header (same logic, slightly larger typography / spacing for web)
  Widget _buildProjectHeader(ProjectEntity project) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.12),
            Theme.of(context).primaryColor.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  project.name,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              _buildPriorityBadge(project.priority),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            project.description ?? 'No description available',
            style: TextStyle(
              fontSize: 17,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildStatusChip(project.status),
              _buildProgressBar(project.progress),
            ],
          ),
          const SizedBox(height: 24),
          _buildDeadlineInfo(project.deadline),
        ],
      ),
    );
  }

  // ── Modules Section (web: nicer card spacing, larger cards)
  Widget _buildModulesSection(BuildContext context, List<ModuleEntity> modules) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 20),
          child: Text(
            'My Tasks',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (modules.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.widgets_outlined,
                    size: 90,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No tasks assigned to you in this project yet',
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          )
        else
          ...modules.map((module) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _buildModuleCard(context, module),
              )),
      ],
    );
  }

  // ── Module Card (larger padding, better spacing for desktop)
  Widget _buildModuleCard(BuildContext context, ModuleEntity module) {
    final isAssignedToMe = module.assignedUsers.contains(widget.currentUserId);
    final progressColor = _getModuleProgressColor(module.progress);

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    module.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (module.description?.isNotEmpty ?? false) ...[
              const SizedBox(height: 12),
              Text(
                module.description!,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
            const SizedBox(height: 24),

            Wrap(
              spacing: 24,
              runSpacing: 16,
              children: [
                Chip(
                  label: Text(module.status ?? 'Unknown'),
                  backgroundColor: Colors.blue.shade50,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  labelStyle: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, size: 20, color: Colors.grey[700]),
                    const SizedBox(width: 8),
                    Text(
                      '${module.estimatedTime.toStringAsFixed(1)} hours estimated',
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),

            Text(
              isAssignedToMe ? 'Your Progress' : 'Task Progress',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: module.progress / 100,
                      minHeight: 14,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  '${module.progress}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: progressColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            if (isAssignedToMe) ...[
              const Text(
                'Update Progress',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),

              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 12,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 16),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 32),
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
                  onChanged: (_) {}, // visual only – update on release
                ),
              ),

              const SizedBox(height: 24),

              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildQuickProgressButton(context, module, 25),
                  _buildQuickProgressButton(context, module, 50),
                  _buildQuickProgressButton(context, module, 75),
                  _buildQuickProgressButton(
                    context,
                    module,
                    100,
                    label: 'Complete Task',
                  ),
                ],
              ),
            ] else ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You are not assigned to this task',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            if (module.startDate != null || module.endDate != null)
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  Text(
                    _formatDateRange(module.startDate, module.endDate),
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Optional sidebar – you can expand this later (stats, team members, activity log, etc.)
  Widget _buildWebSidebar(ProjectEntity project) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Project Quick Info',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSidebarRow('Priority', project.priority.toUpperCase()),
          _buildSidebarRow('Status', project.status.replaceAll('_', ' ').toUpperCase()),
          _buildSidebarRow('Progress', '${project.progress}%'),
          const Divider(height: 32),
          const Text(
            'Coming soon:',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text('• Team members\n• Recent activity\n• Attachments\n• Comments', 
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSidebarRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // The rest remains IDENTICAL to your mobile version
  // ───────────────────────────────────────────────────────────────────────────

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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            status.replaceAll('_', ' ').toUpperCase(),
            style: TextStyle(
              fontSize: 13,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Overall Progress', style: TextStyle(fontWeight: FontWeight.w600)),
              Text('$progress%', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineInfo(DateTime deadline) {
    final isOverdue = DateTime.now().isAfter(deadline);
    final daysRemaining = deadline.difference(DateTime.now()).inDays;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isOverdue ? Colors.red.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOverdue ? Colors.red.shade200 : Colors.blue.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isOverdue ? Icons.warning : Icons.calendar_today,
            size: 24,
            color: isOverdue ? Colors.red : Colors.blue,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOverdue ? 'OVERDUE' : 'DEADLINE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isOverdue ? Colors.red : Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy').format(deadline),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isOverdue ? Colors.red.shade700 : Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isOverdue
                      ? '${daysRemaining.abs()} days overdue'
                      : '$daysRemaining days remaining',
                  style: TextStyle(
                    fontSize: 13,
                    color: isOverdue ? Colors.red.shade600 : Colors.blue.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}