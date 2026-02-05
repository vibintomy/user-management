import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_x/features/lead/domain/entities/available_users_entity.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_bloc.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_event.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_state.dart';

class CreateModuleScreenWeb extends StatefulWidget {
  final String projectId;

  const CreateModuleScreenWeb({super.key, required this.projectId});

  @override
  State<CreateModuleScreenWeb> createState() => _CreateModuleScreenWebState();
}

class _CreateModuleScreenWebState extends State<CreateModuleScreenWeb> {
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
        title: const Text('Create New Module'),
        centerTitle: true,
        elevation: 0,
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
          final isCreatingModule = state is LeadProjectLoading && _hasLoadedUsers;

          return LayoutBuilder(
            builder: (context, constraints) {
              final isVeryWide = constraints.maxWidth > 1200;
              final contentWidth = isVeryWide ? 1100.0 : constraints.maxWidth * 0.92;

              return SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentWidth),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Form(
                        key: _formKey,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left column - Main form fields
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildCardSection(
                                    title: 'Module Information',
                                    child: Column(
                                      children: [
                                        _buildTextField(
                                          controller: _nameController,
                                          label: 'Module Name *',
                                          icon: Icons.label_important,
                                          validator: (v) =>
                                              v?.trim().isEmpty ?? true
                                                  ? 'Required'
                                                  : v!.trim().length > 100
                                                      ? 'Max 100 characters'
                                                      : null,
                                        ),
                                        const SizedBox(height: 24),
                                        _buildTextField(
                                          controller: _descriptionController,
                                          label: 'Description',
                                          icon: Icons.description,
                                          maxLines: 4,
                                          validator: (v) => v != null && v.length > 500
                                              ? 'Max 500 characters'
                                              : null,
                                        ),
                                        const SizedBox(height: 24),
                                        _buildTextField(
                                          controller: _estimatedTimeController,
                                          label: 'Estimated Time (hours) *',
                                          icon: Icons.timer_outlined,
                                          keyboardType: TextInputType.number,
                                          validator: (v) {
                                            if (v?.trim().isEmpty ?? true) {
                                              return 'Required';
                                            }
                                            final h = double.tryParse(v!.trim());
                                            return h == null || h <= 0
                                                ? 'Enter valid hours'
                                                : null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  _buildCardSection(
                                    title: 'Priority',
                                    child: _buildPrioritySelector(),
                                  ),
                                  const SizedBox(height: 32),

                                  _buildCardSection(
                                    title: 'Timeline (Optional)',
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _buildDatePicker(
                                            label: 'Start Date',
                                            selectedDate: _startDate,
                                            onTap: () => _selectStartDate(context),
                                          ),
                                        ),
                                        const SizedBox(width: 24),
                                        Expanded(
                                          child: _buildDatePicker(
                                            label: 'End Date',
                                            selectedDate: _endDate,
                                            onTap: () => _selectEndDate(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  _buildCardSection(
                                    title: 'Additional Notes',
                                    child: _buildTextField(
                                      controller: _notesController,
                                      label: 'Notes',
                                      icon: Icons.note_alt_outlined,
                                      maxLines: 5,
                                      validator: (v) => v != null && v.length > 500
                                          ? 'Max 500 characters'
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 48),
                                ],
                              ),
                            ),

                            if (isVeryWide) const SizedBox(width: 48),

                            // Right column - Team assignment + summary
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildCardSection(
                                    title: 'Assign Team Members',
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (_isLoadingUsers)
                                          const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(32),
                                              child: Column(
                                                children: [
                                                  CircularProgressIndicator(),
                                                  SizedBox(height: 16),
                                                  Text('Loading team members...'),
                                                ],
                                              ),
                                            ),
                                          )
                                        else if (_userLoadError != null)
                                          _buildErrorCard(_userLoadError!)
                                        else ...[
                                          // Selected users
                                          if (_selectedUserIds.isNotEmpty) ...[
                                            const Text(
                                              'Selected Members',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Wrap(
                                              spacing: 12,
                                              runSpacing: 12,
                                              children: _selectedUserIds.map((id) {
                                               final user = _availableUsers.cast<AvailableUserEntity?>()
    .firstWhere((u) => u?.id == id, orElse: () => null);

if (user == null) {
  // handle "not found" case — maybe show error or skip
  return const Chip(label: Text('User not found'));
}

                                                return Chip(
                                                  avatar: CircleAvatar( 
                                                    backgroundColor: Colors.blue.shade700,
                                                    child: Text(
                                                      user.name.isNotEmpty
                                                          ? user.name[0].toUpperCase()
                                                          : 'U',
                                                      style: const TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                  label: Text(user.name),
                                                  onDeleted: () {
                                                    setState(() {
                                                      _selectedUserIds.remove(id);
                                                    });
                                                  },
                                                  deleteIconColor: Colors.red.shade700,
                                                  backgroundColor: Colors.blue.shade50,
                                                );
                                              }).toList(),
                                            ),
                                            const SizedBox(height: 24),
                                          ],

                                          OutlinedButton.icon(
                                            onPressed: _availableUsers.isEmpty
                                                ? null
                                                : _showUserSelectionDialog,
                                            icon: const Icon(Icons.person_add_alt_1),
                                            label: Text(
                                              _availableUsers.isEmpty
                                                  ? 'No available users'
                                                  : 'Select Team Members',
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              minimumSize: const Size(double.infinity, 52),
                                              textStyle: const TextStyle(fontSize: 16),
                                            ),
                                          ),

                                          if (_availableUsers.isEmpty && !_isLoadingUsers)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 16),
                                              child: Text(
                                                'No users available to assign in this project/department',
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 32),

                                  // Submit button (moved to right column for better balance)
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton.icon(
                                      onPressed: isCreatingModule ? null : _handleSubmit,
                                      icon: isCreatingModule
                                          ? const SizedBox.shrink()
                                          : const Icon(Icons.add_circle_outline),
                                      label: isCreatingModule
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              'Create Module',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ── Reusable card wrapper for sections ──────────────────────────────────────
  Widget _buildCardSection({required String title, required Widget child}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  // ── Error display card ──────────────────────────────────────────────────────
  Widget _buildErrorCard(String message) {
    return Card(
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange.shade800, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Failed to load team members',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(color: Colors.orange.shade800),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _loadAvailableUsers,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange.shade800,
                side: BorderSide(color: Colors.orange.shade800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Reuse your existing helper methods (unchanged) ──────────────────────────

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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: validator,
    );
  }

  Widget _buildPrioritySelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: ['low', 'medium', 'high'].map((p) {
        final selected = _selectedPriority == p;
        final color = p == 'high'
            ? Colors.red
            : p == 'medium'
                ? Colors.orange
                : Colors.green;

        return FilterChip(
          label: Text(
            p.toUpperCase(),
            style: TextStyle(
              color: selected ? Colors.white : color,
              fontWeight: FontWeight.w600,
            ),
          ),
          selected: selected,
          selectedColor: color,
          backgroundColor: color.withOpacity(0.12),
          checkmarkColor: Colors.white,
          onSelected: (_) => setState(() => _selectedPriority = p),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? '${selectedDate.day.toString().padLeft(2, '0')}/'
                      '${selectedDate.month.toString().padLeft(2, '0')}/'
                      '${selectedDate.year}'
                  : 'Select date',
              style: TextStyle(
                color: selectedDate != null ? Colors.black87 : Colors.grey,
              ),
            ),
            const Icon(Icons.calendar_month_outlined),
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
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null && mounted) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final initial = _endDate ?? _startDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null && mounted) {
      setState(() => _endDate = picked);
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
                width: 500,
                height: 500,
                child: _availableUsers.isEmpty
                    ? const Center(child: Text('No users available'))
                    : ListView.builder(
                        itemCount: _availableUsers.length,
                        itemBuilder: (context, index) {
                          final user = _availableUsers[index];
                          final selected = tempSelected.contains(user.id);

                          return CheckboxListTile(
                            value: selected,
                            onChanged: (v) {
                              setDialogState(() {
                                if (v == true) {
                                  tempSelected.add(user.id);
                                } else {
                                  tempSelected.remove(user.id);
                                }
                              });
                            },
                            title: Text(user.name),
                            subtitle: Text(user.email),
                            secondary: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                style: TextStyle(color: Colors.blue.shade800),
                              ),
                            ),
                            activeColor: Colors.blue.shade700,
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
                      _selectedUserIds
                        ..clear()
                        ..addAll(tempSelected);
                    });
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Confirm Selection'),
                ),
              ],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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