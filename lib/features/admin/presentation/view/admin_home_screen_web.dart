import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/features/admin/domain/entities/lead_entity.dart';
import 'package:manage_x/features/admin/presentation/bloc/project/project_bloc.dart';
import 'package:manage_x/features/admin/presentation/bloc/project/project_event.dart';
import 'package:manage_x/features/admin/presentation/bloc/project/project_state.dart';
import 'package:manage_x/features/admin/presentation/widgets/admin_overview_chart.dart';


class AdminHomeScreenWeb extends StatelessWidget {
  const AdminHomeScreenWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(45.0),
      child: Column(
        children: [
          const AdminOverviewChart(),
          kheight10,
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const CreateProjectDialog(),
                );
              },
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
        ],
      ),
    );
  }
}

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
                              Text(
                                lead.email,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
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