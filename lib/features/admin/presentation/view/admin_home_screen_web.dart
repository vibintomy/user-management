import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/features/admin/domain/entities/lead_entity.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart'; // adjust path if needed
import 'package:manage_x/features/admin/presentation/bloc/project/project_bloc.dart';
import 'package:manage_x/features/admin/presentation/bloc/project/project_event.dart';
import 'package:manage_x/features/admin/presentation/bloc/project/project_state.dart';
import 'package:manage_x/features/admin/presentation/widgets/admin_overview_chart.dart';

class AdminHomeScreenWeb extends StatefulWidget {
  const AdminHomeScreenWeb({super.key});

  @override
  State<AdminHomeScreenWeb> createState() => _AdminHomeScreenWebState();
}

class _AdminHomeScreenWebState extends State<AdminHomeScreenWeb> {
  @override
  void initState() {
    super.initState();
    // Load projects when screen opens
    context.read<ProjectBloc>().add(const GetAllProjectsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(45.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdminOverviewChart(),
            kheight10,
        
            // Create Project Card – completely unchanged
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const CreateProjectDialog(),
                  ).then((value) {
                    // After dialog closes → reload projects (works even if cancelled)
                    if (mounted) {
                      context.read<ProjectBloc>().add(const GetAllProjectsEvent());
                    }
                  });
                },
                child: Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.blue.shade700, size: 50),
                        Center(
                          child: Text(
                            'Create Project',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        
            kheight30,
        
            // ── Projects List ───────────────────────────────────────
            BlocConsumer<ProjectBloc, ProjectState>(
              listenWhen: (prev, current) =>
                  current is ProjectCreated ||
                  current is ProjectUpdated ||
                  current is ProjectDeleted ||
                  current is ProjectError,
              listener: (context, state) {
                // Reload list after create / update / delete / error
                context.read<ProjectBloc>().add(const GetAllProjectsEvent());
        
                if (state is ProjectError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ProjectLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
        
                if (state is ProjectsLoaded) {
                  final projects = state.projects;
        
                  if (projects.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'No projects yet.\nCreate your first project!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                    );
                  }
        
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Projects',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      kheight15,
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          return _ProjectCard(project: projects[index]);
                        },
                      ),
                    ],
                  );
                }
        
                // For other states (initial, leads loaded, etc.) → show nothing or skeleton
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Project Card with Delete (Edit placeholder) ────────────────────────────────
class _ProjectCard extends StatelessWidget {
  final ProjectEntity project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                _PriorityChip(priority: project.priority),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              project.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 20,
              runSpacing: 8,
              children: [
                _MetaItem(icon: Icons.business, label: project.department),
                _MetaItem(icon: Icons.person, label: project.assignedLeadName ?? 'No lead'),
                _MetaItem(
                  icon: Icons.calendar_today,
                  label: 'Due ${dateFormat.format(project.deadline)}',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              OutlinedButton.icon(
  icon: const Icon(Icons.edit, size: 18),
  label: const Text('Edit'),
  onPressed: () {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditProjectDialog(project: project),
    ).then((value) {
      // Optional: extra safety reload (already handled by BlocConsumer)
      if (context.mounted && value == true) {
        context.read<ProjectBloc>().add(const GetAllProjectsEvent());
      }
    });
  },
),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  tooltip: 'Delete project',
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text('Are you sure? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              context.read<ProjectBloc>().add(DeleteProjectEvent(projectId: project.id));
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final String priority;

  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = switch (priority.toLowerCase()) {
      'low'    => Colors.green,
      'medium' => Colors.blue,
      'high'   => Colors.orange,
      'urgent' => Colors.red,
      _        => Colors.grey,
    };

    return Chip(
      label: Text(priority.toUpperCase(), style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: Colors.grey.shade800)),
      ],
    );
  }
}

// Keep your CreateProjectDialog exactly as it was — no changes needed there
// ===============================================
// NEW: Proper StatefulWidget for the dialog
// ===============================================
class CreateProjectDialog extends StatefulWidget {
  const CreateProjectDialog({super.key});

  @override
  State<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<CreateProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedDepartment;
  String? _selectedLeadId;
  DateTime? _selectedDeadline;
  String _selectedPriority = 'medium';

  final List<String> _departments = [
    'Flutter-mobile',
    'Data science',
    'Web',
  ];

  final List<Map<String, String>> _priorities = [
    {'value': 'low', 'label': 'Low', 'color': '0xFF4CAF50'},
    {'value': 'medium', 'label': 'Medium', 'color': '0xFF2196F3'},
    {'value': 'high', 'label': 'High', 'color': '0xFFFF9800'},
    {'value': 'urgent', 'label': 'Urgent', 'color': '0xFFF44336'},
  ];

  List<LeadEntity> _availableLeads = [];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDeadline) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  void _createProject() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a department')),
      );
      return;
    }
    if (_selectedLeadId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a lead')),
      );
      return;
    }
    if (_selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a deadline')),
      );
      return;
    }

    context.read<ProjectBloc>().add(
          CreateProjectEvent(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            department: _selectedDepartment!,
            assignedLead: _selectedLeadId!,
            deadline: _selectedDeadline!,
            priority: _selectedPriority,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Center(child: Text('Create a new Project')),
      content: SizedBox(
        width: 700,
        height: 700,
        child: BlocConsumer<ProjectBloc, ProjectState>(
          listener: (context, state) {
            if (state is LeadsLoaded) {
              setState(() {
                _availableLeads = state.leads;
                _selectedLeadId = null;
              });
            } else if (state is ProjectCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Project created successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop(true);
            } else if (state is ProjectError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is ProjectLoading;
        
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Project Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Project Name',
                        hintText: 'Enter project name',
                        prefixIcon: Icon(Icons.work),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Project name is required';
                        }
                        if (value.length < 3) {
                          return 'Name must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
        
                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter project description',
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
        
                    // Department
                    DropdownButtonFormField<String>(
                      value: _selectedDepartment,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                        prefixIcon: Icon(Icons.business),
                        border: OutlineInputBorder(),
                      ),
                      items: _departments.map((dept) {
                        return DropdownMenuItem(value: dept, child: Text(dept));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDepartment = value;
                          _selectedLeadId = null;
                          _availableLeads = [];
                        });
                        if (value != null) {
                          context.read<ProjectBloc>().add(
                                GetAvailableLeadsEvent(department: value),
                              );
                        }
                      },
                      validator: (value) =>
                          value == null ? 'Please select a department' : null,
                    ),
                    const SizedBox(height: 16),
        
                    // Lead
                    DropdownButtonFormField<String>(
                      value: _selectedLeadId,
                      decoration: InputDecoration(
                        labelText: 'Assign Lead',
                        prefixIcon: const Icon(Icons.person),
                        border: const OutlineInputBorder(),
                        enabled: _availableLeads.isNotEmpty,
                      ),
                      items: _availableLeads.map((lead) {
                        return DropdownMenuItem(
                          value: lead.id,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                lead.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: _availableLeads.isEmpty
                          ? null
                          : (value) {
                              setState(() {
                                _selectedLeadId = value;
                              });
                            },
                      validator: (value) =>
                          value == null ? 'Please select a lead' : null,
                    ),
        
                    if (_selectedDepartment != null &&
                        _availableLeads.isEmpty &&
                        state is! ProjectLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'No approved leads available in this department',
                          style: TextStyle(color: Colors.orange, fontSize: 12),
                        ),
                      ),
        
                    const SizedBox(height: 16),
        
                    // Deadline
                    InkWell(
                      onTap: _selectDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Deadline',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _selectedDeadline != null
                              ? DateFormat('MMM dd, yyyy')
                                  .format(_selectedDeadline!)
                              : 'Select deadline',
                          style: TextStyle(
                            color: _selectedDeadline != null
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
        
                    // Priority
                    const Text(
                      'Priority',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _priorities.map((priority) {
                        final isSelected =
                            _selectedPriority == priority['value'];
                        return ChoiceChip(
                          label: Text(priority['label']!),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedPriority = priority['value']!;
                              });
                            }
                          },
                          selectedColor: Color(int.parse(priority['color']!))
                              .withOpacity(0.3),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Color(int.parse(priority['color']!))
                                : Colors.grey.shade700,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        BlocBuilder<ProjectBloc, ProjectState>(
          builder: (context, state) {
            final isLoading = state is ProjectLoading;
            return ElevatedButton(
              onPressed: isLoading ? null : _createProject,
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Create'),
            );
          },
        ),
      ],
    );
  }
}
// ===============================================
// Edit Project Dialog — similar structure to Create, but pre-filled
// ===============================================
class EditProjectDialog extends StatefulWidget {
  final ProjectEntity project;

  const EditProjectDialog({super.key, required this.project});

  @override
  State<EditProjectDialog> createState() => _EditProjectDialogState();
}

class _EditProjectDialogState extends State<EditProjectDialog> {
  late final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.project.name);
  late final _descriptionController = TextEditingController(text: widget.project.description);

  late String? _selectedDepartment = widget.project.department;
  late String? _selectedLeadId = widget.project.assignedLeadId; // assuming this is the ID
  late DateTime? _selectedDeadline = widget.project.deadline;
  late String _selectedPriority = widget.project.priority;

  final List<String> _departments = [
    'Flutter-mobile',
    'Data science',
    'Web',
  ];

  final List<Map<String, String>> _priorities = [
    {'value': 'low', 'label': 'Low', 'color': '0xFF4CAF50'},
    {'value': 'medium', 'label': 'Medium', 'color': '0xFF2196F3'},
    {'value': 'high', 'label': 'High', 'color': '0xFFFF9800'},
    {'value': 'urgent', 'label': 'Urgent', 'color': '0xFFF44336'},
  ];

  List<LeadEntity> _availableLeads = [];

  @override
  void initState() {
    super.initState();
    // Immediately load leads for the current department so dropdown is populated
    if (_selectedDepartment != null) {
      context.read<ProjectBloc>().add(
            GetAvailableLeadsEvent(department: _selectedDepartment!),
          );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null && picked != _selectedDeadline) {
      setState(() => _selectedDeadline = picked);
    }
  }

  void _updateProject() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a department')),
      );
      return;
    }
    if (_selectedLeadId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a lead')),
      );
      return;
    }
    if (_selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a deadline')),
      );
      return;
    }

    context.read<ProjectBloc>().add(
          UpdateProjectEvent(
            projectId: widget.project.id,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            department: _selectedDepartment!,
            assignedLead: _selectedLeadId!,
            deadline: _selectedDeadline!,
            priority: _selectedPriority,
            // status: widget.project.status,  // ← add if your entity & event supports status
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Center(child: Text('Edit Project')),
      content: SizedBox(
        width: 700,
        // Removed fixed height + rely on SingleChildScrollView
        child: BlocConsumer<ProjectBloc, ProjectState>(
          listener: (context, state) {
            if (state is LeadsLoaded) {
              setState(() {
                _availableLeads = state.leads;
                // Keep current lead selected if still in list, otherwise clear
                if (!_availableLeads.any((lead) => lead.id == _selectedLeadId)) {
                  _selectedLeadId = null;
                }
              });
            } else if (state is ProjectUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Project updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop(true);
            } else if (state is ProjectError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is ProjectLoading;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Project Name',
                          prefixIcon: Icon(Icons.work),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty || v.trim().length < 3
                                ? 'Name must be at least 3 characters'
                                : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          prefixIcon: Icon(Icons.description),
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 4,
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Description is required'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _selectedDepartment,
                        decoration: const InputDecoration(
                          labelText: 'Department',
                          prefixIcon: Icon(Icons.business),
                          border: OutlineInputBorder(),
                        ),
                        items: _departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartment = value;
                            _selectedLeadId = null;
                            _availableLeads = [];
                          });
                          if (value != null) {
                            context.read<ProjectBloc>().add(
                                  GetAvailableLeadsEvent(department: value),
                                );
                          }
                        },
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _selectedLeadId,
                        decoration: InputDecoration(
                          labelText: 'Assign Lead',
                          prefixIcon: const Icon(Icons.person),
                          border: const OutlineInputBorder(),
                          enabled: _availableLeads.isNotEmpty,
                        ),
                        items: _availableLeads.map((lead) {
                          return DropdownMenuItem(
                            value: lead.id,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(lead.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: _availableLeads.isEmpty
                            ? null
                            : (value) => setState(() => _selectedLeadId = value),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      if (_selectedDepartment != null && _availableLeads.isEmpty && !isLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            'No approved leads available in this department',
                            style: TextStyle(color: Colors.orange, fontSize: 12),
                          ),
                        ),
                      const SizedBox(height: 16),

                      InkWell(
                        onTap: _selectDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Deadline',
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _selectedDeadline != null
                                ? DateFormat('MMM dd, yyyy').format(_selectedDeadline!)
                                : 'Select deadline',
                            style: TextStyle(
                              color: _selectedDeadline != null ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Priority',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _priorities.map((p) {
                          final selected = _selectedPriority == p['value'];
                          return ChoiceChip(
                            label: Text(p['label']!),
                            selected: selected,
                            onSelected: (sel) {
                              if (sel) setState(() => _selectedPriority = p['value']!);
                            },
                            selectedColor: Color(int.parse(p['color']!)).withOpacity(0.3),
                            labelStyle: TextStyle(
                              color: selected ? Color(int.parse(p['color']!)) : Colors.grey.shade700,
                              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        BlocBuilder<ProjectBloc, ProjectState>(
          builder: (context, state) {
            final loading = state is ProjectLoading;
            return ElevatedButton(
              onPressed: loading ? null : _updateProject,
              child: loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Save'),
            );
          },
        ),
      ],
    );
  }
}