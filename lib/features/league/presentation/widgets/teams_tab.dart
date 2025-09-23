import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
import '../../data/team_repository.dart';
import '../../models/team_model.dart';
import '../../data/team_repository_impl.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/theme/app_colors.dart';

class TeamsTab extends StatefulWidget {
  final List<Team> teamsData;

  const TeamsTab({super.key, required this.teamsData});

  @override
  State<TeamsTab> createState() => _TeamsTabState();
}

class _TeamsTabState extends State<TeamsTab> {
  late List<Team> _teams;
  final isEditMode = false.obs;
  late final TeamRepository _repo;

  @override
  void initState() {
    super.initState();
    _teams = List<Team>.from(widget.teamsData);

    try {
      _repo = Get.find<TeamRepository>();
    } catch (_) {
      final apiClient = Get.find<ApiClient>();
      Get.lazyPut<TeamRepository>(() => TeamRepositoryImpl(apiClient));
      _repo = Get.find<TeamRepository>();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Obx(() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 21,
              right: 21,
              top: 24,
              bottom: 12,
            ),
            child: Container(height: 2, color: AppColors.gray),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: screenWidth * 0.1),
                Expanded(
                  child: Text(
                    isEditMode.value ? "Edit Teams" : "Teams",
                    style: const TextStyle(
                      color: AppColors.teamCardBackground,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center, // Center the text
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isEditMode.value)
                      IconButton(
                        icon: const Image(
                          height: 22,
                          width: 22,
                          image: AssetImage("assets/images/add_icon.png"),
                        ),
                        tooltip: "Add Team",
                        onPressed: () {
                          // TODO: Navigate to Add Team screen or show dialog
                          // Get.to(() => AddTeamScreen());
                        },
                      ),
                    IconButton(
                      icon: Image(
                        height: 22,
                        width: 22,
                        image: isEditMode.value
                            ? AssetImage("assets/images/cross_icon.png")
                            : AssetImage("assets/images/edit_icon.png"),
                        color: Colors.white,
                      ),
                      tooltip: isEditMode.value ? "Done" : "Edit",
                      onPressed: () {
                        isEditMode.value = !isEditMode.value;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 1.1,
                          ),
                      itemCount: _teams.length,
                      itemBuilder: (BuildContext context, int index) {
                        final team = _teams[index];
                        return Stack(
                          children: [
                            _TeamGridItem(team: team),
                            if (isEditMode.value)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text(
                                          'Delete team',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        content: const Text(
                                          'Are you sure you want to delete this team?',
                                          style: TextStyle(
                                            color: AppColors.white,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(true),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm != true) return;

                                    // Call delete API
                                    final result = await _repo.deleteTeam(
                                      team.id,
                                    );

                                    // handle result in a safe, runtime-checked way
                                    final res = result;
                                    bool handled = false;
                                    try {
                                      // If the result implements fold (e.g. Either-like), use it
                                      final foldFn = (res as dynamic).fold;
                                      if (foldFn is Function) {
                                        (res as dynamic).fold(
                                          (fail) {
                                            final msg =
                                                (fail as dynamic)?.message ??
                                                'Delete failed';
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(content: Text(msg)),
                                            );
                                          },
                                          (success) {
                                            setState(() {
                                              _teams.removeAt(index);
                                            });
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text('Team deleted'),
                                              ),
                                            );
                                          },
                                        );
                                        handled = true;
                                      }
                                    } catch (_) {
                                      // ignore and fallback below
                                    }

                                    if (!handled) {
                                      // Fallback: common NetworkResult shapes
                                      final dyn = res as dynamic;
                                      final bool success =
                                          (dyn.data != null) ||
                                          (dyn.isSuccess == true) ||
                                          (dyn.status == 'success');

                                      if (success) {
                                        setState(() {
                                          _teams.removeAt(index);
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Team deleted'),
                                          ),
                                        );
                                      } else {
                                        final msg =
                                            dyn.message ??
                                            dyn.error?.message ??
                                            'Delete failed';
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(msg.toString()),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: const Image(
                                      image: AssetImage(
                                        'assets/images/cross_icon_black.png',
                                      ),
                                      width: 10,
                                      height: 10,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    _buildSeeTableButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSeeTableButton() {
    return OutlinedButton(
      onPressed: () {
        // Get.to(() => const YourNextScreen());
      },
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFF353535),
        side: const BorderSide(width: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Text(
        'See Table >',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _TeamGridItem extends StatelessWidget {
  final Team team;

  const _TeamGridItem({required this.team});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: AppColors.googleBorderColor,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 18.0,
            backgroundColor: Colors.transparent,
            backgroundImage: team.logoPhotoUrl.isNotEmpty
                ? NetworkImage(team.logoPhotoUrl)
                : const AssetImage('assets/images/group_logo.png')
                      as ImageProvider,
          ),
          const SizedBox(height: 8),
          Text(
            team.teamName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.buttonText,
            ),
          ),
        ],
      ),
    );
  }
}
