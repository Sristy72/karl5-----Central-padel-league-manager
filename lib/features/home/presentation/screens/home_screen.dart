import 'package:flutter/material.dart';
import 'package:flutter_karlfive223_manager/features/Create_league/presentation/screens/create_league_screen.dart';
import 'package:get/get.dart';

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
    final controller = Get.put(HomeController()); //! Do not comment this line

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.leagueBackgroundGrey,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final controller = Get.find<HomeController>();
                final name = controller.userName.value.isNotEmpty
                    ? controller.userName.value
                    : 'Guest';
                return Text(
                  'Hello $name,',
                  style: const TextStyle(color: AppColors.white, fontSize: 18),
                );
              }),
              const SizedBox(height: 4),
              const Text(
                "Welcome to Padel app",
                style: TextStyle(color: AppColors.white, fontSize: 14),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                backgroundColor: Colors.grey[850],
                child: IconButton(
                  onPressed: () {
                    // TODO: button logic here
                    Get.to(() => CreateLeagueScreen());
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
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
                const SizedBox(height: 20),
                const CustomSearchBar(),
                const SizedBox(height: 15),

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
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            "Game Reminder",
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        GameReminderShimmer(),
                        SizedBox(height: 20),
                        LeagueUpdateShimmer(),
                        SizedBox(height: 20),
                        NextMatchShimmer(),
                        SizedBox(height: 20),
                        QuickStatsShimmer(),
                        SizedBox(height: 20),
                        FixturesShimmer(),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          "Game Reminder",
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      GameReminderWidget(),
                      SizedBox(height: 20),
                      LeagueUpdateWidget(),
                      SizedBox(height: 20),
                      NextMatchWidget(),
                      SizedBox(height: 20),
                      QuickStatsWidget(),
                      SizedBox(height: 20),
                      FixturesWidget(),
                    ],
                  );
                }),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 0),
    );
  }
}
