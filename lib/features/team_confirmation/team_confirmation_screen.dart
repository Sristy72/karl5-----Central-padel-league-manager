import 'package:flutter/material.dart';
import 'models/team.dart';
import 'widgets/team_row_widget.dart';

class TeamConfirmationScreen extends StatefulWidget {
  const TeamConfirmationScreen({super.key});

  @override
  _TeamConfirmationScreenState createState() => _TeamConfirmationScreenState();
}

class _TeamConfirmationScreenState extends State<TeamConfirmationScreen> {
  String selectedLeague = "PREMIER LEAGUE";

  final leagues = ["PREMIER LEAGUE", "CHAMPIONS LEAGUE", "NATIONAL LEAGUE"];

  final List<Team> teams = List.generate(
    15,
    (index) => Team(
      teamName: "Deathradder $index",
      teamMembers: "Mosh - Dan - Player $index",
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Team Confirmation",
          style: TextStyle(
            color: Colors.green,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const Divider(color: Colors.grey, thickness: 1),

          // Dropdown with constrained width so it doesn't overflow on small screens
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isDense: true,
                      value: selectedLeague,
                      dropdownColor: Colors.grey[900],
                      items: leagues
                          .map(
                            (league) => DropdownMenuItem(
                              value: league,
                              child: Text(
                                league,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLeague = value!;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: const [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Team name",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Team members",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "Status",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          Expanded(
            child: ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return TeamRowWidget(team: teams[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
