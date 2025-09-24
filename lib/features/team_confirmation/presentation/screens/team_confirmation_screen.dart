import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_karlfive223_manager/features/league/presentation/controllers/league_controller.dart';
import 'package:flutter_karlfive223_manager/features/league/models/league_model.dart';
import 'package:flutter_karlfive223_manager/features/league/models/team_model.dart';
import '../widgets/team_row_widget.dart';
// removed unused import: app_colors

class TeamConfirmationScreen extends StatefulWidget {
  const TeamConfirmationScreen({super.key});

  @override
  State<TeamConfirmationScreen> createState() => _TeamConfirmationScreenState();
}

class _TeamConfirmationScreenState extends State<TeamConfirmationScreen> {
  League? _selectedLeague;
  List<Team> _teams = [];

  LeagueController? _leagueCtrl;

  @override
  void initState() {
    super.initState();
    try {
      _leagueCtrl = Get.find<LeagueController>();
      if (_leagueCtrl!.leagues.isNotEmpty) {
        _selectedLeague = _leagueCtrl!.leagues.first;
        // Only show teams that are pending confirmation
        _teams = List<Team>.from(
          _selectedLeague!.addTeams.where(
            (t) => t.applicationStatus == 'pending',
          ),
        );
      }
      // listen for changes to leagues and update selection if needed
      ever(_leagueCtrl!.leagues, (_) {
        if (_selectedLeague == null && _leagueCtrl!.leagues.isNotEmpty) {
          setState(() {
            _selectedLeague = _leagueCtrl!.leagues.first;
            _teams = List<Team>.from(
              _selectedLeague!.addTeams.where(
                (t) => t.applicationStatus == 'pending',
              ),
            );
          });
        }
      });
    } catch (_) {}
  }

  void _onLeagueSelected(League? league) {
    setState(() {
      _selectedLeague = league;
      _teams = league != null
          ? List<Team>.from(
              league.addTeams.where((t) => t.applicationStatus == 'pending'),
            )
          : [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
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

          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() {
                    if (_leagueCtrl == null) {
                      return const Text(
                        'No leagues available',
                        style: TextStyle(color: Colors.green),
                      );
                    }
                    final list = _leagueCtrl!.leagues;
                    if (list.isEmpty) {
                      return const Text(
                        'No leagues available',
                        style: TextStyle(color: Colors.green),
                      );
                    }
                    // ensure selected is valid and only pending teams
                    if (_selectedLeague == null && list.isNotEmpty) {
                      _selectedLeague = list.first;
                      _teams = List<Team>.from(
                        _selectedLeague!.addTeams.where(
                          (t) => t.applicationStatus == 'pending',
                        ),
                      );
                    }
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<League>(
                        isDense: true,
                        value: _selectedLeague,
                        dropdownColor: Colors.grey[900],
                        items: list.map((league) {
                          return DropdownMenuItem<League>(
                            value: league,
                            child: Text(
                              league.leagueName,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: _onLeagueSelected,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.green,
                        ),
                      ),
                    );
                  }),
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
            child: _teams.isEmpty
                ? const Center(
                    child: Text(
                      'No teams',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: _teams.length,
                    itemBuilder: (context, index) {
                      final team = _teams[index];
                      return TeamRowWidget(
                        team: team,
                        onDeleted: () {
                          setState(() {
                            _teams.removeWhere((t) => t.id == team.id);
                          });
                        },
                        onStatusUpdated: (status) {
                          if (status == 'approved') {
                            setState(() {
                              _teams.removeWhere((t) => t.id == team.id);
                            });
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
