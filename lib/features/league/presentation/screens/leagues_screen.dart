import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/app_bottom_navbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../presentation/controllers/league_controller.dart';
import '../widgets/league_card.dart';

class LeaguesScreen extends StatefulWidget {
  const LeaguesScreen({super.key});

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LeagueController>();

    return Scaffold(
      backgroundColor: AppColors.leagueBackgroundGrey,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text('Error: ${controller.errorMessage}'));
        } else if (controller.leagues.isEmpty) {
          return const Center(child: Text('No leagues available'));
        } else {
          return ListView.builder(
            itemCount: controller.leagues.length,
            itemBuilder: (context, index) {
              return LeagueCard(league: controller.leagues[index]);
            },
          );
        }
      }),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 1),
    );
  }
}
