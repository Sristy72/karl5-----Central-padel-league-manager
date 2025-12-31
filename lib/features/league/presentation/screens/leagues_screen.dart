import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/app_bottom_navbar.dart';
import '../../../../core/common/widgets/shimmer_widgets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../presentation/controllers/league_controller.dart';
import '../widgets/league_card.dart';

class LeaguesScreen extends StatefulWidget {
  const LeaguesScreen({super.key});

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final controller = Get.find<LeagueController>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.fetchNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LeagueController>();

    return Scaffold(
      backgroundColor: AppColors.leagueBackgroundGrey,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LeagueListShimmer();
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text('Error: ${controller.errorMessage}'));
        } else if (controller.leagues.isEmpty) {
          return const Center(child: Text('No leagues available'));
        } else {
          return ListView.builder(
            controller: _scrollController,
            itemCount: controller.leagues.length +
                (controller.isFetchingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.leagues.length) {
                return LeagueCard(league: controller.leagues[index]);
              }

              // bottom loader
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            },
          );
        }
      }),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 1),
    );
  }
}
