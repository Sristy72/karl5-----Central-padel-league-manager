import 'package:flutter/material.dart';
import 'package:flutter_karlfive223_manager/features/Create_league/presentation/screens/create_league_screen.dart';
import 'package:get/get.dart';

import '../../../../core/common/constants/app_images.dart';
import '../../../../core/common/widgets/app_bottom_navbar.dart';
import '../../../../core/common/widgets/shimmer_widgets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../controller/home_controller.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/fixtures_widget.dart';
import '../widgets/game_reminder_widget.dart';
import '../widgets/league_update_widget.dart';
import '../widgets/next_match_widget.dart';
import '../widgets/quick_stats_widget.dart';
import '../widgets/search_results_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final controller = Get.put(HomeController());
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          backgroundColor: AppColors.leagueBackgroundGrey,
          elevation: 0,
          title: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // LEFT: greeting text
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth * 0.45,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() {
                            final name = controller.userName.value.isNotEmpty
                                ? controller.userName.value
                                : 'Guest';
                            return Text(
                              'Hello $name,',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: screenWidth < 350 ? 12 : 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            );
                          }),
                          SizedBox(height: screenWidth < 350 ? 2 : 4),
                          Text(
                            "Welcome to Padel app",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: screenWidth < 350 ? 8 : 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),


                  // CENTER: circular responsive logo
                  Align(
                    alignment: Alignment(
                      screenWidth < 350 ? 0.2 : 0.17,
                      0,
                    ),
                    child: SizedBox(
                      height: kToolbarHeight * 0.85,
                      width: kToolbarHeight * 0.85,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(1),
                        child: ClipOval(
                          child: Image.asset(
                            AppImages.homelogo,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: screenWidth < 350 ? 8 : 12),
              child: CircleAvatar(
                radius: screenWidth < 350 ? 16 : 20,
                backgroundColor: Colors.grey[850],
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    // TODO: button logic here
                    Get.to(() => CreateLeagueScreen());
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: screenWidth < 350 ? 18 : 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: Container(
        color: AppColors.leagueBackgroundGrey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenWidth < 350 ? 12 : 20),
                const CustomSearchBar(),
                SizedBox(height: screenWidth < 350 ? 10 : 15),

                // Show search results when searching, otherwise show regular content
                Obx(() {
                  final controller = Get.find<HomeController>();

                  if (controller.isSearching.value) {
                    return const SearchResultsWidget();
                  }

                  // Show shimmer loaders while loading
                  if (controller.isLoading.value) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth < 400 ? 12.0 : 24.0,
                          ),
                          child: Text(
                            "Game Reminder",
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth < 350 ? 16 : 18,
                            ),
                          ),
                        ),
                        SizedBox(height: screenWidth < 350 ? 8 : 12),
                        const GameReminderShimmer(),
                        SizedBox(height: screenWidth < 350 ? 16 : 20),
                        const LeagueUpdateShimmer(),
                        SizedBox(height: screenWidth < 350 ? 16 : 20),
                        const NextMatchShimmer(),
                        SizedBox(height: screenWidth < 350 ? 16 : 20),
                        const QuickStatsShimmer(),
                        SizedBox(height: screenWidth < 350 ? 16 : 20),
                        const FixturesShimmer(),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth < 400 ? 12.0 : 24.0,
                        ),
                        child: Text(
                          "Game Reminder",
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth < 350 ? 16 : 18,
                          ),
                        ),
                      ),
                      SizedBox(height: screenWidth < 350 ? 8 : 12),
                      const GameReminderWidget(),
                      SizedBox(height: screenWidth < 350 ? 16 : 20),
                      const LeagueUpdateWidget(),
                      SizedBox(height: screenWidth < 350 ? 16 : 20),
                      const NextMatchWidget(),
                      SizedBox(height: screenWidth < 350 ? 16 : 20),
                      const QuickStatsWidget(),
                      SizedBox(height: screenWidth < 350 ? 16 : 20),
                      const FixturesWidget(),
                    ],
                  );
                }),

                SizedBox(height: screenWidth < 350 ? 12 : 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 0),
    );
  }
}
