import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart';
import 'package:manage_x/features/lead/domain/entities/available_users_entity.dart';
import 'package:manage_x/features/lead/domain/entities/module_entity.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_bloc.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_event.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_state.dart';
import 'package:manage_x/features/lead/presentation/pages/create%20_module_screen.dart';
import 'package:manage_x/features/lead/presentation/view/create_module_screen_mobile.dart';

class ProjectDetailsScreenMobile  extends StatefulWidget {
  final String projectId;

  const ProjectDetailsScreenMobile({super.key, required this.projectId});

  @override
  State<ProjectDetailsScreenMobile> createState() => _ProjectDetailsScreenMobileState();
}

class _ProjectDetailsScreenMobileState extends State<ProjectDetailsScreenMobile> {
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
      appBar: AppBar(title: const Text('Project Details')),
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
          // State mapping
          ProjectEntity? project = _cachedProject;
          List<ModuleEntity> modules = _cachedModules;

          if (state is ProjectDetailsLoaded) {
            project = state.project;
            modules = state.modules;

            _cachedProject = project;
            _cachedModules = modules;

            // Initialize assigned users only once (first meaningful load)

            if ((state is LeadProjectLoading && _cachedProject == null) ||
                project == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<LeadProjectBloc>().add(
                  LoadProjectDetailsEvent(widget.projectId),
                );

                await Future.delayed(const Duration(milliseconds: 600));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProjectHeader(context, project!),
                    const Divider(height: 1),
                    _buildProjectStats(project),
                    const Divider(height: 1),

                    const Divider(height: 1),
                    _buildModulesSection(context, modules),
                  ],
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
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
        label: const Text('Add Module'),
      ),
    );
  }

  // ── UI Helper Methods ─────────────────────────────────────────────────────

  Widget _buildProjectHeader(BuildContext context, ProjectEntity project) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildPriorityBadge(project.priority),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            project.description,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          _buildStatusChip(project.status),
          const SizedBox(height: 16),
          _buildProgressBar(project.progress),
          const SizedBox(height: 16),
          _buildDeadlineInfo(project.deadline),
        ],
      ),
    );
  }

  Widget _buildProjectStats(ProjectEntity project) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Uncomment and adjust when you need these stats
          // _buildStatItem('Est. Hours', '${project.totalEstimatedHours.toStringAsFixed(0)}h', Icons.schedule, Colors.blue),
          // _buildStatItem('Actual Hours', '${project.totalActualHours.toStringAsFixed(0)}h', Icons.timer, Colors.orange),
          // _buildStatItem('Points', '${project.basePoints}', Icons.star, Colors.amber),
        ],
      ),
    );
  }

  Widget _buildModulesSection(
    BuildContext context,
    List<ModuleEntity> modules,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Modules',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (modules.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.widgets_outlined,
                      size: 60,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No modules yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...modules.map((module) => _buildModuleCard(context, module)),
        ],
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, ModuleEntity module) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          module.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (module.description != null) ...[
              const SizedBox(height: 4),
              Text(
                module.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 8),
                Text(
                  '${module.estimatedTime}h',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: module.progress / 100,
              backgroundColor: Colors.grey.shade200,
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              _showDeleteConfirmation(context, module);
            }
            // Add 'edit' handling if you implement it
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
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
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress < 30
                  ? Colors.red
                  : progress < 70
                  ? Colors.orange
                  : Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeadlineInfo(DateTime deadline) {
    final isOverdue = DateTime.now().isAfter(deadline);
    final daysRemaining = deadline.difference(DateTime.now()).inDays;

    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 16,
          color: isOverdue ? Colors.red : Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Text(
          'Deadline: ${DateFormat('MMM dd, yyyy').format(deadline)}',
          style: TextStyle(
            color: isOverdue ? Colors.red : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        if (!isOverdue && daysRemaining >= 0)
          Text(
            '($daysRemaining days left)',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        if (isOverdue)
          const Text(
            '(OVERDUE)',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
