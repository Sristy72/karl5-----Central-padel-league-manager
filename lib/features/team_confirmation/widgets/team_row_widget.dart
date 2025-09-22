import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/team.dart';

class TeamRowWidget extends StatelessWidget {
  final Team team;

  const TeamRowWidget({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Icon(
                    Icons.sports_baseball,
                    color: Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      team.teamName,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Text(
                team.teamMembers,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.white,
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          minimumSize: const Size(70, 32),
                        ),
                        onPressed: () {},
                        child: const Text("View details"),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.white,
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          minimumSize: const Size(70, 32),
                        ),
                        onPressed: () {},
                        child: const Text("Approve"),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.white,
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          minimumSize: const Size(70, 32),
                        ),
                        onPressed: () {},
                        child: const Text("Reject"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
