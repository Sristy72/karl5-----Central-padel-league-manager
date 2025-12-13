import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';
import '../screens/home_standings_screen.dart';

class QuickStatsWidget extends StatelessWidget {
  const QuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width < 350 ? 12 : 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Quick Stats",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),

            //* <--- Table Header --->

            //! <--- Quick Stats --->
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: MediaQuery.of(context).size.width < 350
                          ? 8
                          : 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(
                          width: 140, // Must match the team column width below
                          child: Text(
                            "Teams",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            "GP",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            "W",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            "L",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: Text(
                            "Pts",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: Text(
                            "+/-",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider (optional, for visual separation)
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Colors.grey.shade800,
                  ),

                  // Data Rows
                  ...controller.quickStats.asMap().entries.map((entry) {
                    final index = entry.key;
                    final stat = entry.value;
                    final imageUrl = (stat["imageUrl"] ?? '').toString();

                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade800,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Team column - same width as header
                          SizedBox(
                            width: MediaQuery.of(context).size.width < 350
                                ? 130
                                : 160,
                            child: Row(
                              children: [
                                Text(
                                  "${index + 1}${_getOrdinal(index + 1)}  ",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),

                                // ... [Keep your existing Builder with player logic unchanged] ...
                                Builder(
                                  builder: (_) {
                                    final controller =
                                        Get.find<HomeController>();
                                    final teamName = (stat["name"] ?? '')
                                        .toString();

                                    List<Map<String, String>> players = [];
                                    for (final lm in controller.leagueMatches) {
                                      if (lm.teamOne.teamName == teamName) {
                                        final cap = lm.teamOne.captainName;
                                        final partner = lm.teamOne.partnerName;
                                        final logo = lm.teamOne.logoPhotoUrl;
                                        if (cap.isNotEmpty) {
                                          players.add({
                                            'name': cap,
                                            'imageUrl': logo,
                                          });
                                        }
                                        if (partner.isNotEmpty) {
                                          players.add({
                                            'name': partner,
                                            'imageUrl': logo,
                                          });
                                        }
                                        break;
                                      }
                                      if (lm.teamTwo.teamName == teamName) {
                                        final cap = lm.teamTwo.captainName;
                                        final partner = lm.teamTwo.partnerName;
                                        final logo = lm.teamTwo.logoPhotoUrl;
                                        if (cap.isNotEmpty) {
                                          players.add({
                                            'name': cap,
                                            'imageUrl': logo,
                                          });
                                        }
                                        if (partner.isNotEmpty) {
                                          players.add({
                                            'name': partner,
                                            'imageUrl': logo,
                                          });
                                        }
                                        break;
                                      }
                                    }

                                    if (players.isNotEmpty) {
                                      //* <--- Render up to two players inline. --->
                                      final toShow = players.take(2).toList();
                                      return Column(
                                        children: toShow.map((pl) {
                                          final playerName = pl['name'] ?? '';
                                          final playerImage =
                                              (pl['imageUrl'] ?? '').toString();
                                          return Row(
                                            children: [
                                              CircleAvatar(
                                                radius:
                                                    MediaQuery.of(
                                                          context,
                                                        ).size.width <
                                                        350
                                                    ? 10
                                                    : 12,
                                                backgroundColor:
                                                    Colors.grey[800],
                                                backgroundImage:
                                                    playerImage.isNotEmpty
                                                    ? NetworkImage(playerImage)
                                                    : null,
                                                child: playerImage.isEmpty
                                                    ? const Icon(
                                                        Icons.person,
                                                        size: 14,
                                                        color: Colors.white70,
                                                      )
                                                    : null,
                                              ),
                                              const SizedBox(width: 4),
                                              SizedBox(
                                                width:
                                                    MediaQuery.of(
                                                          context,
                                                        ).size.width <
                                                        350
                                                    ? 50
                                                    : 80,
                                                child: Text(
                                                  playerName,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(
                                                              context,
                                                            ).size.width <
                                                            350
                                                        ? 12
                                                        : 14,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      );
                                    }

                                    return Row(
                                      children: [
                                        CircleAvatar(
                                          radius:
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width <
                                                  350
                                              ? 12
                                              : 14,
                                          backgroundImage: imageUrl.isNotEmpty
                                              ? NetworkImage(imageUrl)
                                              : null,
                                          child: imageUrl.isEmpty
                                              ? const Icon(
                                                  Icons.sports,
                                                  size: 14,
                                                  color: Colors.white70,
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 4),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width <
                                                  350
                                              ? 70
                                              : 80,
                                          child: Text(
                                            stat["name"] ?? "",
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          // Numeric columns - give them fixed or reasonable min widths
                          // Numeric columns - matching header widths
                          SizedBox(
                            width: 40,
                            child: Text(
                              "${stat["GP"]}",
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: Text(
                              "${stat["W"]}",
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: Text(
                              "${stat["L"]}",
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: Text(
                              "${stat["Pts"]}",
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: Text(
                              "${stat["+/-"]}",
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            //* <--- "See All" link --->
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Get.to(() => const HomeStandingsScreen());
                },
                child: const Text(
                  "See All",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper for 1st, 2nd, 3rd, etc.
  String _getOrdinal(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return "th";
    }
    switch (number % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }
}
