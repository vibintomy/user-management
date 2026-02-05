import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_x/features/lead/domain/entities/available_users_entity.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_bloc.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_event.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_state.dart';

class CreateModuleScreenMobile extends StatefulWidget {
  final String projectId;

  const CreateModuleScreenMobile({super.key, required this.projectId});

  @override
  State<CreateModuleScreenMobile> createState() => _CreateModuleScreenMobileState();
}

class _CreateModuleScreenMobileState extends State<CreateModuleScreenMobile> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _estimatedTimeController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedPriority = 'medium';
  DateTime? _startDate;
  DateTime? _endDate;

  // User assignment fields
  List<AvailableUserEntity> _availableUsers = [];
  final List<String> _selectedUserIds = [];
  bool _isLoadingUsers = false;
  bool _hasLoadedUsers = false;
  String? _userLoadError;

  @override
  void initState() {
    super.initState();
    // Load available users for assignment
    _loadAvailableUsers();
  }

  void _loadAvailableUsers() {
    setState(() {
      _isLoadingUsers = true;
      _userLoadError = null;
    });
    context.read<LeadProjectBloc>().add(
          LoadAvailableUsersEvent(widget.projectId),
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _estimatedTimeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Module'),
      ),
      body: BlocConsumer<LeadProjectBloc, LeadProjectState>(
        listener: (context, state) {
          if (state is ModuleCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Module created successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }
          
          if (state is LeadProjectError && _isLoadingUsers) {
            // This error is for loading users
            setState(() {
              _isLoadingUsers = false;
              _hasLoadedUsers = true;
              _userLoadError = state.message;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to load users: ${state.message}'),
                backgroundColor: Colors.orange,
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: _loadAvailableUsers,
                ),
              ),
            );
          } else if (state is LeadProjectError && !_isLoadingUsers) {
            // This error is for module creation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          
          if (state is AvailableUsersLoaded) {
            setState(() {
              _availableUsers = state.users;
              _isLoadingUsers = false;
              _hasLoadedUsers = true;
              _userLoadError = null;
            });
            
            if (state.users.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No users available in your department'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          // Only show loading for module creation, not user loading
          final isCreatingModule = state is LeadProjectLoading && _hasLoadedUsers;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Module Details ─────────────────────────────────────────────
                  _buildSectionTitle('Module Details'),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _nameController,
                    label: 'Module Name',
                    icon: Icons.label,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Module name is required';
                      }
                      if (value.trim().length > 100) {
                        return 'Name cannot exceed 100 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description (Optional)',
                    icon: Icons.description,
                    maxLines: 3,
                    validator: (value) {
                      if (value != null && value.length > 500) {
                        return 'Description cannot exceed 500 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _estimatedTimeController,
                    label: 'Estimated Time (hours)',
                    icon: Icons.access_time,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Estimated time is required';
                      }
                      final hours = double.tryParse(value);
                      if (hours == null || hours <= 0) {
                        return 'Enter a valid number of hours';
                      }
                      return null;
                    },
                  ),

                  // ── Assigned Users ─────────────────────────────────────────────
                  const SizedBox(height: 32),
                  _buildSectionTitle('Assigned Team Members'),
                  const SizedBox(height: 12),

                  if (_isLoadingUsers)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Loading available users...'),
                          ],
                        ),
                      ),
                    )
                  else if (_userLoadError != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.warning, color: Colors.orange.shade700),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Failed to load users',
                                  style: TextStyle(
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _userLoadError!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton.icon(
                            onPressed: _loadAvailableUsers,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    // Selected users chips
                    if (_selectedUserIds.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedUserIds.map((userId) {
                          // Find user in available users list
                          AvailableUserEntity? user;
                          try {
                            user = _availableUsers.firstWhere(
                              (u) => u.id == userId,
                            );
                          } catch (e) {
                            // User not found, create a placeholder
                            user = null;
                          }
                          
                          // If user not found, create placeholder
                          final displayUser = user ?? AvailableUserEntity(
                            id: userId,
                            name: 'Unknown User',
                            email: '',
                            department: '',
                            isActive: true,
                          );
                          
                          return Chip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.blue.shade700,
                              child: Text(
                                displayUser.name.isNotEmpty ? displayUser.name[0].toUpperCase() : 'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            label: Text(displayUser.name),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () {
                              setState(() {
                                _selectedUserIds.remove(userId);
                              });
                            },
                            backgroundColor: Colors.blue.shade50,
                            labelStyle: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 12),

                    // Add member button
                    OutlinedButton.icon(
                      onPressed: _availableUsers.isEmpty 
                          ? null 
                          : _showUserSelectionDialog,
                      icon: const Icon(Icons.person_add),
                      label: Text(
                        _availableUsers.isEmpty
                            ? 'No Available Users'
                            : 'Add Team Member',
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),

                    if (_availableUsers.isEmpty && !_isLoadingUsers)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'No users available in your department',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                  ],

                  // ── Priority & Timeline ────────────────────────────────────────
                  const SizedBox(height: 32),
                  _buildSectionTitle('Priority'),
                  const SizedBox(height: 12),
                  _buildPrioritySelector(),

                  const SizedBox(height: 32),
                  _buildSectionTitle('Timeline (Optional)'),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildDatePicker(
                          label: 'Start Date',
                          selectedDate: _startDate,
                          onTap: () => _selectStartDate(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDatePicker(
                          label: 'End Date',
                          selectedDate: _endDate,
                          onTap: () => _selectEndDate(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _notesController,
                    label: 'Notes (Optional)',
                    icon: Icons.note,
                    maxLines: 3,
                    validator: (value) {
                      if (value != null && value.length > 500) {
                        return 'Notes cannot exceed 500 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 40),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isCreatingModule ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isCreatingModule
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Create Module',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Helper Widgets ────────────────────────────────────────────────────────

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPrioritySelector() {
    return Wrap(
      spacing: 8,
      children: ['low', 'medium', 'high'].map((priority) {
        final isSelected = _selectedPriority == priority;
        Color color;
        switch (priority) {
          case 'high':
            color = Colors.red;
            break;
          case 'medium':
            color = Colors.orange;
            break;
          default:
            color = Colors.green;
        }

        return ChoiceChip(
          label: Text(
            priority.toUpperCase(),
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontWeight: FontWeight.bold,
            ),
          ),
          selected: isSelected,
          selectedColor: color,
          backgroundColor: color.withOpacity(0.1),
          onSelected: (selected) {
            setState(() {
              _selectedPriority = priority;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                  : 'Select date',
              style: TextStyle(
                color: selectedDate != null ? Colors.black : Colors.grey,
              ),
            ),
            const Icon(Icons.calendar_today, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _showUserSelectionDialog() {
    final tempSelected = List<String>.from(_selectedUserIds);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Select Team Members'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: _availableUsers.isEmpty
                    ? const Center(child: Text('No available users'))
                    : ListView.builder(
                        itemCount: _availableUsers.length,
                        itemBuilder: (context, index) {
                          final user = _availableUsers[index];
                          final isSelected = tempSelected.contains(user.id);

                          return CheckboxListTile(
                            title: Text(user.name),
                            subtitle: Text(user.email),
                            secondary: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            value: isSelected,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                if (value == true) {
                                  tempSelected.add(user.id);
                                } else {
                                  tempSelected.remove(user.id);
                                }
                              });
                            },
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedUserIds.clear();
                      _selectedUserIds.addAll(tempSelected);
                    });
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<LeadProjectBloc>().add(
            CreateModuleEvent(
              projectId: widget.projectId,
              name: _nameController.text.trim(),
              description: _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim(),
              estimatedTime: double.parse(_estimatedTimeController.text.trim()),
              priority: _selectedPriority,
              startDate: _startDate,
              endDate: _endDate,
              notes: _notesController.text.trim().isEmpty
                  ? null
                  : _notesController.text.trim(),
              assignedUsers: _selectedUserIds,
            ),
          );
    }
  }
}