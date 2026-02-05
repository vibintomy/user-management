import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_bloc.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_event.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_state.dart';
import 'package:manage_x/features/lead/presentation/pages/project_details_screen.dart';
import 'package:manage_x/features/user/presentation/bloc/user_profile_bloc.dart';
import 'package:manage_x/features/user/presentation/bloc/user_profile_state.dart';

class LeadHomescreenWeb extends StatefulWidget {
  const LeadHomescreenWeb({super.key});

  @override
  State<LeadHomescreenWeb> createState() => _LeadHomescreenWebState();
}

class _LeadHomescreenWebState extends State<LeadHomescreenWeb> {
  String selectFilter = 'today';
  bool showFilter = false;

  @override
  void initState() {
    super.initState();
    // Load once when the screen mounts.
    context.read<LeadProjectBloc>().add(LoadProjectsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(60),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               BlocBuilder<ProfileBloc, ProfileState>(
  builder: (context, state) {
    String userName = 'User';

    if (state is ProfileLoaded) {
      userName = state.user.name;
    }

    return Text(
      'Hi 👋\n$userName',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
        wordSpacing: 10,
      ),
    );
  },
),
              Row(
                children: [
                 
                  kwidth15,
                  BlocBuilder<ProfileBloc, ProfileState>(
  builder: (context, state) {
    String initial = '?';

    if (state is ProfileLoaded &&
        state.user.name.trim().isNotEmpty) {
      initial = state.user.name
          .trim()
          .substring(0, 1)
          .toUpperCase();
    }

    return ClipOval(
      child: Container(
        color: Colors.grey,
        height: 50,
        width: 50,
        child: Center(
          child: Text(
            initial,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  },
)
                ],
              ),
            ],
          ),
          kheight10,

          SizedBox(
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// 🔹 Centered Choice Chips
                if (showFilter)
                  Center(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        chipTheme: Theme.of(
                          context,
                        ).chipTheme.copyWith(checkmarkColor: AppColors.white),
                      ),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildChip('all', 'All'),
                          _buildChip('today', 'Today'),
                          _buildChip('current_month', 'Current Month'),
                          _buildChip('last_month', 'Last Month'),
                        ],
                      ),
                    ),
                  ),

                /// 🔹 Filter Icon on Right
                Positioned(
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        showFilter = !showFilter;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.darkBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.filter_list, color: AppColors.darkBlue),
                    ),
                  ),
                ),
              ],
            ),
          ),
          kheight15,
          BlocConsumer<LeadProjectBloc, LeadProjectState>(
            listener: (context, state) {
              if (state is LeadProjectError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is LeadProjectLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ProjectsLoaded) {
                if (state.projects.isEmpty) {
                  return _buildEmptyState();
                }

                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<LeadProjectBloc>().add(LoadProjectsEvent());
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    child: ListView.builder(
                      itemCount: state.projects.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ProjectCard(
                            projectEntity: state.projects[index],
                          ),
                        );
                      },
                    ),
                  ),
                );
              }

              // Initial / other states
              return _buildEmptyState();
            },
          ),
        ],
      ),
    );
  }

  ChoiceChip _buildChip(String value, String label) {
    final isSelected = selectFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: selectFilter == value,

      selectedColor: AppColors.darkBlue,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.white : AppColors.black,
        fontWeight: FontWeight.w500,
      ),
      onSelected: (_) {
        setState(() {
          selectFilter = value;
        });
      },
    );
  }
}

class ProjectCard extends StatelessWidget {
  final ProjectEntity projectEntity;
  const ProjectCard({super.key, required this.projectEntity});

  @override
  Widget build(BuildContext context) {
    final deadline = projectEntity.deadline
        .toLocal()
        .toIso8601String()
        .split('T')
        .first;

    Color priorityColor(String p) {
      switch (p.toLowerCase()) {
        case 'high':
          return Colors.redAccent;
        case 'medium':
          return Colors.orangeAccent;
        case 'low':
          return Colors.green;
        default:
          return AppColors.dottedGrey;
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth.clamp(0, 720).toDouble()
            : 720.0;

        return Center(
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProjectDetailsScreen(projectId: projectEntity.id)));
            },
            child: SizedBox(
              width: cardWidth,
              child: Stack(
                children: [
                  Container(
                    height: 157,
                    decoration: const BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  Positioned.fill(
                    top: 1,
                    left: 1,
                    right: 1,
                    bottom: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    projectEntity.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.more_vert),
                              ],
                            ),
                            kheight15,
                            Container(
                              height: 30,
                              width: 100,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30),
                                ),
                                color: priorityColor(projectEntity.priority),
                              ),
                              child: Center(
                                child: Text(
                                  projectEntity.priority,
                                  style: const TextStyle(color: AppColors.white),
                                ),
                              ),
                            ),
                            kheight10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month),
                                    const SizedBox(width: 6),
                                    Text('Due $deadline'),
                                  ],
                                ),
                                // Placeholder avatar stack (can be wired to assigned users later)
                                SizedBox(
                                  width: 100,
                                  child: Stack(
                                    children: [
                                      _AvatarChip(
                                        background: AppColors.gold,
                                        label:
                                            (projectEntity.assignedLeadName
                                                    ?.trim()
                                                    .isNotEmpty ??
                                                false)
                                            ? projectEntity.assignedLeadName!
                                                  .trim()
                                                  .substring(0, 1)
                                                  .toUpperCase()
                                            : 'L',
                                      ),
                                      const Positioned(
                                        top: 0,
                                        left: 25,
                                        child: _AvatarChip(
                                          background: AppColors.blue,
                                          label: 'U',
                                        ),
                                      ),
                                      const Positioned(
                                        top: 0,
                                        left: 50,
                                        child: _AvatarChip(
                                          background: AppColors.dottedGrey,
                                          label: '+1',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AvatarChip extends StatelessWidget {
  final Color background;
  final String label;

  const _AvatarChip({required this.background, required this.label});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: 40,
        width: 40,
        color: background,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.folder_open, size: 80, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(
          'No projects assigned',
          style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
        ),
      ],
    ),
  );
}
