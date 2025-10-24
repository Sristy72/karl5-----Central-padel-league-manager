import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/network/api_client.dart';
import '../../../features/home/presentation/screens/home_screen.dart';
import '../../../features/league/presentation/screens/leagues_screen.dart';
import '../../../features/notification/presentation/screen/notification_dummy_screen.dart';
import '../../../features/team_details/data/repo/team_repo_impl.dart';
import '../../../features/team_details/presentation/controllers/team_controller.dart';
import '../../../features/team_members_profile/data/models/team_member_model.dart';
import '../../../features/team_members_profile/data/repo/contact_us_repo_impl.dart';
import '../../../features/team_members_profile/data/repo/user_profile_repo_impl.dart';
import '../../../features/team_members_profile/presentation/controllers/contact_us_controller.dart';
import '../../../features/team_members_profile/presentation/controllers/profile_controller.dart';
import '../../../features/team_members_profile/presentation/screens/profile_info_screen.dart';

// Create a GetX controller for navigation
class BottomNavController extends GetxController {
  final currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller if not already initialized
    final controller = Get.put(BottomNavController());
    controller.currentIndex.value = currentIndex;

    Widget _buildNavItem({
      required int index,
      required String icon,
      required String activeIcon,
      required String label,
    }) {
      return Obx(() {
        final bool isSelected = controller.currentIndex.value == index;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Green line indicator
            Container(
              height: 3,
              width: 40,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 4),

            // Icon
            Image.asset(isSelected ? activeIcon : icon, width: 24, height: 24),

            const SizedBox(height: 4),

            // Label
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected ? AppColors.primaryGreen : AppColors.gray,
              ),
            ),
          ],
        );
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0D1B2A),
        border: Border(
          top: BorderSide(color: Colors.grey.shade900, width: 0.5),
        ),
      ),
      child: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: (index) {
            controller.changeIndex(index);

            // Use GetX for navigation with smooth transitions
            if (index == 0) {
              Get.offAll(
                () => const HomeScreen(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 50),
              );
            } else if (index == 1) {
              Get.offAll(
                () => const LeaguesScreen(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 50),
              );
            } else if (index == 2) {
              Get.offAll(
                () => NotificationScreen(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 50),
              );
            } else if (index == 3) {
              // Create a default team member model for the profile
              final defaultMember = TeamMemberModel(
                id: '1',
                name: 'User Profile',
                role: 'Player',
                imageUrl: 'assets/images/profile.png',
                matches: 0,
                level: 1,
                firstName: 'User',
                lastName: 'Profile',
                email: '',
                phone: '',
                birthday: '',
                gender: '',
              );

              // Initialize controllers if not already initialized
              if (!Get.isRegistered<ProfileController>() ||
                  !Get.isRegistered<TeamController>() ||
                  !Get.isRegistered<ContactUsController>()) {
                // Get the API client from GetX
                final apiClient = Get.find<ApiClient>();

                // Initialize Profile Controller
                if (!Get.isRegistered<ProfileController>()) {
                  final userProfileRepo = Get.put(
                    UserProfileRepoImpl(apiClient: apiClient),
                  );
                  Get.put(ProfileController(repository: userProfileRepo));
                }

                // Initialize Team Controller
                if (!Get.isRegistered<TeamController>()) {
                  final teamRepo = Get.put(TeamRepoImpl(apiClient: apiClient));
                  Get.put(TeamController(repo: teamRepo));
                }

                // Initialize Contact Us Controller
                if (!Get.isRegistered<ContactUsController>()) {
                  final contactUsRepo = Get.put(
                    ContactUsRepoImpl(apiClient: apiClient),
                  );
                  Get.put(ContactUsController(contactUsRepo));
                }
              }

              Get.offAll(
                () => ProfileInfoScreen(member: defaultMember),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 50),
              );
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,

          selectedFontSize: 0,
          unselectedFontSize: 0,
          selectedItemColor: Colors.transparent,
          unselectedItemColor: Colors.transparent,

          items: [
            BottomNavigationBarItem(
              icon: _buildNavItem(
                index: 0,
                icon: "assets/images/nav_home_off.png",
                activeIcon: "assets/images/nav_home_on.png",
                label: "Home",
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildNavItem(
                index: 1,
                icon: "assets/images/nav_match_off.png",
                activeIcon: "assets/images/nav_match_on.png",
                label: "Matches",
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildNavItem(
                index: 2,
                icon: "assets/icons/Vector.png",
                activeIcon: "assets/icons/Vector.png",
                label: "League",
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildNavItem(
                index: 3,
                icon: "assets/images/nav_prof_off.png",
                activeIcon: "assets/images/nav_prof_on.png",
                label: "Profile",
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
