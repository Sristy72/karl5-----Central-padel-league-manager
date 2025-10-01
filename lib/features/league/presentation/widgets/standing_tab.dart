import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/standing_model.dart';

class StandingTab extends StatefulWidget {
  final List<Standing> standingsData;

  const StandingTab({super.key, required this.standingsData});

  @override
  State<StandingTab> createState() => _StandingTabState();
}

class _StandingTabState extends State<StandingTab> {
  int? editingIndex;
  late List<Standing> editableStandingsData;

  @override
  void initState() {
    super.initState();
    // Create a copy of the standings data for editing
    editableStandingsData = widget.standingsData
        .map(
          (standing) => Standing(
            id: standing.id,
            leagueId: standing.leagueId,
            leagueName: standing.leagueName,
            teamId: standing.teamId,
            position: standing.position,
            teamName: standing.teamName,
            teamLogoUrl: standing.teamLogoUrl,
            played: standing.played,
            won: standing.won,
            drawn: standing.drawn,
            lost: standing.lost,
            goalDifference: standing.goalDifference,
            points: standing.points,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 12),
        child: SizedBox(
          width: double.infinity,
          child: SizedBox(
            width: screenWidth,
            child: DataTable(
              columnSpacing: 8.0,
              horizontalMargin: 8,
              headingRowColor: WidgetStateProperty.all(
                AppColors.leagueBackgroundGrey,
              ),
              dataRowColor: WidgetStateProperty.all(AppColors.white),
              border: const TableBorder(
                horizontalInside: BorderSide(
                  color: AppColors.leagueBackgroundGrey,
                  width: 10,
                ),
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    'Pos',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Team',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'P',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'W',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'D',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'L',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    '+/-',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'PTS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Edit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              rows: editableStandingsData.asMap().entries.map((entry) {
                final index = entry.key;
                final standing = entry.value;
                final isEditing = editingIndex == index;

                return DataRow(
                  cells: [
                    DataCell(Text(standing.position.toString())),
                    DataCell(
                      Container(
                        width: 80,
                        child: isEditing
                            ? TextField(
                                controller: TextEditingController(
                                  text: standing.teamName,
                                ),
                                style: TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  isDense: true,
                                ),
                                onChanged: (value) {
                                  editableStandingsData[index] = Standing(
                                    id: standing.id,
                                    leagueId: standing.leagueId,
                                    leagueName: standing.leagueName,
                                    teamId: standing.teamId,
                                    position: standing.position,
                                    teamName: value,
                                    teamLogoUrl: standing.teamLogoUrl,
                                    played: standing.played,
                                    won: standing.won,
                                    drawn: standing.drawn,
                                    lost: standing.lost,
                                    goalDifference: standing.goalDifference,
                                    points: standing.points,
                                  );
                                },
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 10.0,
                                    backgroundImage:
                                        (standing.teamLogoUrl.startsWith(
                                              'http',
                                            ) ||
                                            standing.teamLogoUrl.startsWith(
                                              'https',
                                            ))
                                        ? NetworkImage(standing.teamLogoUrl)
                                        : AssetImage(standing.teamLogoUrl)
                                              as ImageProvider,
                                  ),
                                  const SizedBox(width: 6.0),
                                  Flexible(
                                    child: Text(
                                      standing.teamName,
                                      style: TextStyle(fontSize: 11),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    DataCell(
                      isEditing
                          ? SizedBox(
                              width: 20,
                              child: TextField(
                                controller: TextEditingController(
                                  text: standing.played.toString(),
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 11),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2,
                                    vertical: 0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  isDense: true,
                                ),
                                onChanged: (value) {
                                  final intValue =
                                      int.tryParse(value) ?? standing.played;
                                  editableStandingsData[index] = Standing(
                                    id: standing.id,
                                    leagueId: standing.leagueId,
                                    leagueName: standing.leagueName,
                                    teamId: standing.teamId,
                                    position: standing.position,
                                    teamName: standing.teamName,
                                    teamLogoUrl: standing.teamLogoUrl,
                                    played: intValue,
                                    won: standing.won,
                                    drawn: standing.drawn,
                                    lost: standing.lost,
                                    goalDifference: standing.goalDifference,
                                    points: standing.points,
                                  );
                                },
                              ),
                            )
                          : Text(
                              standing.played.toString(),
                              style: TextStyle(fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    DataCell(
                      isEditing
                          ? SizedBox(
                              width: 20,
                              child: TextField(
                                controller: TextEditingController(
                                  text: standing.won.toString(),
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 11),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2,
                                    vertical: 0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  isDense: true,
                                ),
                                onChanged: (value) {
                                  final intValue =
                                      int.tryParse(value) ?? standing.won;
                                  editableStandingsData[index] = Standing(
                                    id: standing.id,
                                    leagueId: standing.leagueId,
                                    leagueName: standing.leagueName,
                                    teamId: standing.teamId,
                                    position: standing.position,
                                    teamName: standing.teamName,
                                    teamLogoUrl: standing.teamLogoUrl,
                                    played: standing.played,
                                    won: intValue,
                                    drawn: standing.drawn,
                                    lost: standing.lost,
                                    goalDifference: standing.goalDifference,
                                    points: standing.points,
                                  );
                                },
                              ),
                            )
                          : Text(
                              standing.won.toString(),
                              style: TextStyle(fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    DataCell(
                      isEditing
                          ? SizedBox(
                              width: 20,
                              child: TextField(
                                controller: TextEditingController(
                                  text: standing.drawn.toString(),
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 11),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2,
                                    vertical: 0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  isDense: true,
                                ),
                                onChanged: (value) {
                                  final intValue =
                                      int.tryParse(value) ?? standing.drawn;
                                  editableStandingsData[index] = Standing(
                                    id: standing.id,
                                    leagueId: standing.leagueId,
                                    leagueName: standing.leagueName,
                                    teamId: standing.teamId,
                                    position: standing.position,
                                    teamName: standing.teamName,
                                    teamLogoUrl: standing.teamLogoUrl,
                                    played: standing.played,
                                    won: standing.won,
                                    drawn: intValue,
                                    lost: standing.lost,
                                    goalDifference: standing.goalDifference,
                                    points: standing.points,
                                  );
                                },
                              ),
                            )
                          : Text(
                              standing.drawn.toString(),
                              style: TextStyle(fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    DataCell(
                      isEditing
                          ? SizedBox(
                              width: 20,
                              child: TextField(
                                controller: TextEditingController(
                                  text: standing.lost.toString(),
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 11),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2,
                                    vertical: 0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  isDense: true,
                                ),
                                onChanged: (value) {
                                  final intValue =
                                      int.tryParse(value) ?? standing.lost;
                                  editableStandingsData[index] = Standing(
                                    id: standing.id,
                                    leagueId: standing.leagueId,
                                    leagueName: standing.leagueName,
                                    teamId: standing.teamId,
                                    position: standing.position,
                                    teamName: standing.teamName,
                                    teamLogoUrl: standing.teamLogoUrl,
                                    played: standing.played,
                                    won: standing.won,
                                    drawn: standing.drawn,
                                    lost: intValue,
                                    goalDifference: standing.goalDifference,
                                    points: standing.points,
                                  );
                                },
                              ),
                            )
                          : Text(
                              standing.lost.toString(),
                              style: TextStyle(fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    DataCell(
                      isEditing
                          ? SizedBox(
                              width: 20,
                              child: TextField(
                                controller: TextEditingController(
                                  text: standing.goalDifference.toString(),
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 11),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2,
                                    vertical: 0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  isDense: true,
                                ),
                                onChanged: (value) {
                                  final intValue =
                                      int.tryParse(value) ??
                                      standing.goalDifference;
                                  editableStandingsData[index] = Standing(
                                    id: standing.id,
                                    leagueId: standing.leagueId,
                                    leagueName: standing.leagueName,
                                    teamId: standing.teamId,
                                    position: standing.position,
                                    teamName: standing.teamName,
                                    teamLogoUrl: standing.teamLogoUrl,
                                    played: standing.played,
                                    won: standing.won,
                                    drawn: standing.drawn,
                                    lost: standing.lost,
                                    goalDifference: intValue,
                                    points: standing.points,
                                  );
                                },
                              ),
                            )
                          : Text(
                              standing.goalDifference.toString(),
                              style: TextStyle(fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    DataCell(
                      isEditing
                          ? SizedBox(
                              width: 20,
                              child: TextField(
                                controller: TextEditingController(
                                  text: standing.points.toString(),
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 11),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2,
                                    vertical: 0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  isDense: true,
                                ),
                                onChanged: (value) {
                                  final intValue =
                                      int.tryParse(value) ?? standing.points;
                                  editableStandingsData[index] = Standing(
                                    id: standing.id,
                                    leagueId: standing.leagueId,
                                    leagueName: standing.leagueName,
                                    teamId: standing.teamId,
                                    position: standing.position,
                                    teamName: standing.teamName,
                                    teamLogoUrl: standing.teamLogoUrl,
                                    played: standing.played,
                                    won: standing.won,
                                    drawn: standing.drawn,
                                    lost: standing.lost,
                                    goalDifference: standing.goalDifference,
                                    points: intValue,
                                  );
                                },
                              ),
                            )
                          : Text(
                              standing.points.toString(),
                              style: TextStyle(fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    DataCell(
                      Container(
                        width: isEditing ? 50 : 40,
                        child: isEditing
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Save button (replaces the edit icon while editing)
                                  IconButton(
                                    icon: Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        editingIndex = null;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Changes saved for ${standing.teamName}',
                                            ),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      });
                                    },
                                  ),
                                ],
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.black,
                                  size: 18,
                                ),
                                onPressed: () {
                                  setState(() {
                                    editingIndex = index;
                                  });
                                },
                                constraints: BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ), // DataTable
          ), // SingleChildScrollView (horizontal)
        ), // SizedBox
      ), // Container
    ); // SingleChildScrollView (outer)
  }
}
