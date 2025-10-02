import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../models/standing_model.dart';
import '../../data/league_repository_impl.dart';

class StandingTab extends StatefulWidget {
  final List<Standing> standingsData;

  const StandingTab({super.key, required this.standingsData});

  @override
  State<StandingTab> createState() => _StandingTabState();
}

class _StandingTabState extends State<StandingTab> {
  int? editingIndex;
  late List<Standing> editableStandingsData;
  bool _isSaving = false;

  // Repository for API calls
  late final LeagueRepositoryImpl _repository;

  @override
  void initState() {
    super.initState();
    _repository = LeagueRepositoryImpl(apiClient: ApiClient());

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

  Future<void> _saveStandingUpdates(int index) async {
    final standing = editableStandingsData[index];
    final original = widget.standingsData[index];

    setState(() => _isSaving = true);

    // Build update payload with only changed fields
    final updates = <String, dynamic>{};

    if (standing.played != original.played) {
      updates['played'] = standing.played;
    }
    if (standing.won != original.won) {
      updates['won'] = standing.won;
    }
    if (standing.drawn != original.drawn) {
      updates['drawn'] = standing.drawn;
    }
    if (standing.lost != original.lost) {
      updates['lost'] = standing.lost;
    }
    if (standing.goalDifference != original.goalDifference) {
      updates['goalDifference'] = standing.goalDifference;
    }
    if (standing.points != original.points) {
      updates['points'] = standing.points;
    }

    if (updates.isEmpty) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No changes to save')));
      return;
    }

    final result = await _repository.updateStanding(standing.id, updates);

    result.fold(
      (failure) {
        if (mounted) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update standing: ${failure.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      (success) {
        if (mounted) {
          setState(() => _isSaving = false);

          // Update the original data
          widget.standingsData[index] = standing;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Standing updated for ${standing.teamName}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
    );
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
              columnSpacing: 12.0,
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
                                    horizontal: 2,
                                    vertical: 2,
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
                              width: 25,
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
                                    vertical: 2,
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
                              width: 25,
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
                                    vertical: 2,
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
                              width: 25,
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
                                    vertical: 2,
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
                              width: 25,
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
                                    vertical: 2,
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
                              width: 25,
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
                                    vertical: 2,
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
                              width: 25,
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
                                    vertical: 2,
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
                            ? _isSaving
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.green,
                                      ),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Save button (replaces the edit icon while editing)
                                        IconButton(
                                          icon: Icon(
                                            Icons.check,
                                            color: Colors.green,
                                            size: 18,
                                          ),
                                          onPressed: () async {
                                            await _saveStandingUpdates(index);
                                            setState(() {
                                              editingIndex = null;
                                            });
                                          },
                                          constraints: BoxConstraints(
                                            minWidth: 32,
                                            minHeight: 32,
                                          ),
                                          padding: EdgeInsets.zero,
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
