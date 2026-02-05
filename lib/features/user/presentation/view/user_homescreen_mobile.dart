import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_x/core/constants/app_colors.dart';
import 'package:manage_x/core/widgets/spacing.dart';
import 'package:manage_x/features/admin/domain/entities/project_entity.dart';
import 'package:manage_x/features/user/presentation/bloc/user_profile_bloc.dart';
import 'package:manage_x/features/user/presentation/bloc/user_profile_state.dart';
import 'package:manage_x/features/user/presentation/bloc/user_project_bloc.dart';
import 'package:manage_x/features/user/presentation/bloc/user_project_event.dart';
import 'package:manage_x/features/user/presentation/bloc/user_project_state.dart';
import 'package:manage_x/features/user/presentation/pages/user_project_details.dart';
import 'package:manage_x/features/user/presentation/view/user_project_details_mobile.dart';

class UserHomescreenMobile extends StatefulWidget {
  const UserHomescreenMobile({super.key});

  @override
  State<UserHomescreenMobile> createState() => _UserHomescreenMobileState();
}

class _UserHomescreenMobileState extends State<UserHomescreenMobile> {
  String selectFilter = 'today';
  bool showFilter = false;

  @override
  void initState() {
    super.initState();
    context.read<UserProjectBloc>().add(LoadMyProjectsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Greeting + Profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                    ],
                  ),
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

              const SizedBox(height: 20),

              // Search + Filter toggle
              Row(
                children: [
                 
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showFilter = !showFilter;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.darkBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.filter_list,
                        color: AppColors.darkBlue,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Filter chips (horizontal scrollable when visible)
              if (showFilter)
                SizedBox(
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildChip('all', 'All'),
                      const SizedBox(width: 12),
                      _buildChip('today', 'Today'),
                      const SizedBox(width: 12),
                      _buildChip('current_month', 'This Month'),
                      const SizedBox(width: 12),
                      _buildChip('last_month', 'Last Month'),
                    ],
                  ),
                ),

              if (showFilter) const SizedBox(height: 16),

              // Projects list
              Expanded(
                child: BlocConsumer<UserProjectBloc, UserProjectState>(
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
                   

                    if (state is MyProjectsLoaded) {
                      // Optional: you can keep or remove this auto-refresh
                      // WidgetsBinding.instance.addPostFrameCallback((_) { ... });

                      if (state.projects.isEmpty) {
                        return _buildEmptyState();
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<UserProjectBloc>().add(
                                RefreshUserProjectsEvent(),
                              );
                          await Future.delayed(const Duration(milliseconds: 600));
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 24),
                          itemCount: state.projects.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ProjectCard(
                                projectEntity: state.projects[index],
                               
                              ),
                            );
                          },
                        ),
                      );
                    }

                    return _buildEmptyState();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String value, String label) {
    final isSelected = selectFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.darkBlue,
      backgroundColor: Colors.grey.shade100,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      onSelected: (_) {
        setState(() {
          selectFilter = value;
        });
      },
    );
  }
}

// ────────────────────────────────────────────────
// Mobile-optimized Project Card
// ────────────────────────────────────────────────
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
        final profileState = context.watch<ProfileBloc>().state;

        String? currentUserId;
        if (profileState is ProfileLoaded) {
          currentUserId =
              profileState.user.id; // Assuming your User model has 'id' field
        }
        return Center(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProjectDetailsScreenMobile(
                    projectId: projectEntity.id,
                    currentUserId: currentUserId!,
                  ),
                ),
              );
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30),
                                ),
                                color: priorityColor(projectEntity.priority),
                              ),
                              child: Center(
                                child: Text(
                                  projectEntity.priority,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                  ),
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
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
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
        Icon(
          Icons.folder_open_outlined,
          size: 72,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 16),
        Text(
          'No projects assigned yet',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pull down to refresh',
          style: TextStyle(color: Colors.grey.shade500),
        ),
      ],
    ),
  );
}