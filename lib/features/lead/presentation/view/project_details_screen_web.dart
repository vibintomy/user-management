import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:manage_x/core/widgets/custom_button.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart';
import 'package:manage_x/features/bottom_navigation/lead_bottom_navigation/lead_bottom_navigation.dart';
import 'package:manage_x/features/lead/domain/entities/module_entity.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_bloc.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_event.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_state.dart';
import 'package:manage_x/features/lead/presentation/pages/create%20_module_screen.dart';
import 'package:manage_x/features/lead/presentation/view/create_module_screen_mobile.dart';

class ProjectDetailsScreenWeb extends StatefulWidget {
  final String projectId;

  const ProjectDetailsScreenWeb({super.key, required this.projectId});

  @override
  State<ProjectDetailsScreenWeb> createState() =>
      _ProjectDetailsScreenWebState();
}

class _ProjectDetailsScreenWebState extends State<ProjectDetailsScreenWeb> {
  ProjectEntity? _cachedProject;
  List<ModuleEntity> _cachedModules = [];

  @override
  void initState() {
    super.initState();
    context.read<LeadProjectBloc>().add(
      LoadProjectDetailsEvent(widget.projectId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<LeadProjectBloc, LeadProjectState>(
        listener: (context, state) {
          if (state is LeadProjectError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
            context.read<LeadProjectBloc>().add(
              LoadProjectDetailsEvent(widget.projectId),
            );
          }

          if (state is ModuleCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Module created successfully'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<LeadProjectBloc>().add(
              LoadProjectDetailsEvent(widget.projectId),
            );
          }

          if (state is ModuleDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            context.read<LeadProjectBloc>().add(
              LoadProjectDetailsEvent(widget.projectId),
            );
          }

          if (state is UsersAssigned || state is UserRemoved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state is UsersAssigned
                      ? state.message
                      : (state as UserRemoved).message,
                ),
                backgroundColor: Colors.green,
              ),
            );
            context.read<LeadProjectBloc>().add(
              LoadProjectDetailsEvent(widget.projectId),
            );
          }
        },
        builder: (context, state) {
          ProjectEntity? project = _cachedProject;
          List<ModuleEntity> modules = _cachedModules;

          if (state is ProjectDetailsLoaded) {
            project = state.project;
            modules = state.modules;

            _cachedProject = project;
            _cachedModules = modules;
          }

          if (project == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<LeadProjectBloc>().add(
                LoadProjectDetailsEvent(widget.projectId),
              );
              await Future.delayed(const Duration(milliseconds: 800));
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 1100;
                final contentMaxWidth = isWide
                    ? 1080.0
                    : constraints.maxWidth * 0.92;

                return SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentMaxWidth),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildProjectHeaderWeb(context, project!),
                            const SizedBox(height: 32),
                            _buildProjectStatsWeb(project),
                            const SizedBox(height: 32),
                            _buildModulesSectionWeb(context, modules),
                            const SizedBox(height: 80),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LeadBottomNavigation(),
                                    ),
                                  );
                                },
                                child: Text('Done'),
                              ),
                            ), // space before FAB
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<LeadProjectBloc>(),
                child: CreateModuleScreen(projectId: widget.projectId),
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add New Module'),
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // ── Web-optimized Header ─────────────────────────────────────────────────────
  Widget _buildProjectHeaderWeb(BuildContext context, ProjectEntity project) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        project.description ?? 'No description provided',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                _buildPriorityBadge(project.priority),
              ],
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 24,
              runSpacing: 16,
              children: [
                _buildStatusChip(project.status),
                SizedBox(
                  width: 240,
                  child: _buildProgressBar(project.progress),
                ),
                _buildDeadlineInfo(project.deadline),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Web Stats Row ────────────────────────────────────────────────────────────
  Widget _buildProjectStatsWeb(ProjectEntity project) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // _buildStatItemWeb(
            //   'Estimated Hours',
            //   '${project.totalEstimatedHours?.toStringAsFixed(1) ?? '—'} h',
            //   Icons.schedule,
            //   Colors.blue,
            // ),
            // _buildStatItemWeb(
            //   'Actual Hours',
            //   '${project.totalActualHours?.toStringAsFixed(1) ?? '—'} h',
            //   Icons.timer,
            //   Colors.orange,
            // ),
            // _buildStatItemWeb(
            //   'Story Points',
            //   '${project.basePoints ?? '—'}',
            //   Icons.star,
            //   Colors.amber,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItemWeb(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, size: 36, color: color),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // ── Modules Section (web: grid or wider cards) ───────────────────────────────
  Widget _buildModulesSectionWeb(
    BuildContext context,
    List<ModuleEntity> modules,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Project Modules',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            if (modules.isNotEmpty)
              Text(
                '${modules.length} module${modules.length == 1 ? '' : 's'}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
          ],
        ),
        const SizedBox(height: 24),
        if (modules.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Column(
                children: [
                  Icon(
                    Icons.widgets_outlined,
                    size: 90,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No modules created yet',
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Click the + button to add your first module',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 520,
              mainAxisExtent: 200,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemCount: modules.length,
            itemBuilder: (context, index) {
              return _buildModuleCardWeb(context, modules[index]);
            },
          ),
      ],
    );
  }

  Widget _buildModuleCardWeb(BuildContext context, ModuleEntity module) {
    final progressColor = module.progress < 30
        ? Colors.red
        : module.progress < 70
        ? Colors.orange
        : Colors.green;

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    module.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      _showDeleteConfirmation(context, module);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 12),
                          Text('Edit Module'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 12),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (module.description?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              Text(
                module.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],

            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  '${module.estimatedTime.toStringAsFixed(1)} h estimated',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: progressColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${module.progress}%',
                    style: TextStyle(
                      color: progressColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: module.progress / 100,
                minHeight: 10,

                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Reuse your existing helpers (unchanged) ──────────────────────────────────

  void _showDeleteConfirmation(BuildContext context, ModuleEntity module) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Module'),
        content: Text('Are you sure you want to delete "${module.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<LeadProjectBloc>().add(
                DeleteModuleEvent(
                  moduleId: module.id,
                  projectId: widget.projectId,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
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
        color: color.withOpacity(0.15),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Text(
            status.replaceAll('_', ' ').toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
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
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            Text(
              '$progress%',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
        const SizedBox(height: 10),
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
    );
  }

  Widget _buildDeadlineInfo(DateTime deadline) {
    final isOverdue = DateTime.now().isAfter(deadline);
    final daysRemaining = deadline.difference(DateTime.now()).inDays;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isOverdue ? Colors.red.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOverdue ? Colors.red.shade200 : Colors.blue.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOverdue ? Icons.warning : Icons.calendar_today,
            color: isOverdue ? Colors.red : Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isOverdue ? 'OVERDUE' : 'Deadline',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isOverdue ? Colors.red : Colors.blue,
                ),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(deadline),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isOverdue ? Colors.red.shade800 : Colors.blue.shade800,
                ),
              ),
              if (isOverdue)
                Text(
                  '${daysRemaining.abs()} days overdue',
                  style: TextStyle(fontSize: 13, color: Colors.red.shade700),
                )
              else
                Text(
                  '$daysRemaining days remaining',
                  style: TextStyle(fontSize: 13, color: Colors.blue.shade700),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
