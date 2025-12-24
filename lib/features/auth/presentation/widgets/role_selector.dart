import 'package:flutter/material.dart';

class RoleSelector extends StatefulWidget {
  final String selectedRole;
  final Function(String) onRoleChanged;
    final String selectedDepartment;
  final Function(String) onDepartmentChanged;
  final String? roleError;
final String? departmentError;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.selectedDepartment,
    required this.onDepartmentChanged,
     this.roleError,
  this.departmentError,
  });

  @override
  State<RoleSelector> createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<RoleSelector> {


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LEFT — Role
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Role'),
            const SizedBox(height: 10),
            Row(
              children: [
                _RoleCard(
                  title: 'User',
                  isSelected: widget.selectedRole == 'user',
                  onTap: () => widget.onRoleChanged('user'),
                ),
                const SizedBox(width: 10),
                _RoleCard(
                  title: 'Lead',
                  isSelected: widget.selectedRole == 'lead',
                  onTap: () => widget.onRoleChanged('lead'),
                ),
              ],
            ),
             if (widget.roleError != null) ...[
      const SizedBox(height: 4),
      Text(
        widget.roleError!,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      ),
    ],
          ],
        ),

       /// RIGHT — Department
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text('Department'),
    const SizedBox(height: 10),

    SizedBox(
      width: 150,
      height: 40,
      child: DropdownButtonFormField<String>(
       value: widget.selectedDepartment.isEmpty
      ? null
      : widget.selectedDepartment,
  isExpanded: true,

  hint: const Text(
    'None',
    style: TextStyle(
      color: Colors.grey,
      fontSize: 10,
      fontWeight: FontWeight.w600,
    ),
  ),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(value: 'Flutter-mobile', child: Text('Flutter-mobile')),
          DropdownMenuItem(value: 'Data science', child: Text('Data science')),
          DropdownMenuItem(value: 'Web', child: Text('Web')),
        ],
        onChanged: (value) {
          if (value != null) {
            widget.onDepartmentChanged(value);
          }
        },
      ),
    ),

    /// ✅ Department error appears HERE (under dropdown)
    if (widget.departmentError != null) ...[
      const SizedBox(height: 4),
      SizedBox(
        width: 150, // align with dropdown width
        child: Text(
          widget.departmentError!,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
      ),
    ],
  ],
),

      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 30,
        width: 60,
        child: Container(
        
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.grey.shade100,
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}