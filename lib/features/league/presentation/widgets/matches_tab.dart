import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/league_repository_impl.dart';
import '../../models/league_model.dart';
import '../../models/match_model.dart';
import '../../models/team_model.dart';

class MatchesTab extends StatelessWidget {
  final List<Match> matchesData;

  const MatchesTab({super.key, required this.matchesData});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: matchesData.length,
      itemBuilder: (context, index) {
        final match = matchesData[index];
        return _MatchCard(match: match);
      },
    );
  }
}

class _MatchCard extends StatefulWidget {
  final Match match;

  const _MatchCard({required this.match});

  @override
  State<_MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<_MatchCard> {
  bool _isEditing = false;
  bool _isSaving = false;

  // Repository for API calls
  late final LeagueRepositoryImpl _repository;

  // Available leagues from API
  List<League> _availableLeagues = [];
  bool _isLoadingLeagues = false;

  // Controllers for editable fields
  late TextEditingController _arenaController;
  late TextEditingController _scoreController;
  late DateTime _selectedDateTime;
  String? _selectedLeague;
  String? _selectedLeagueId;
  Team? _selectedWinner;
  bool _isMatchComplete = false;

  @override
  void initState() {
    super.initState();
    _repository = LeagueRepositoryImpl(apiClient: ApiClient());

    _arenaController = TextEditingController(text: widget.match.venueName);
    _scoreController = TextEditingController(
      text: widget.match.formattedScore(),
    );
    _selectedDateTime = widget.match.matchDateTime;
    _selectedLeague = widget.match.leagueName;
    _selectedLeagueId = widget.match.leagueId;
    _isMatchComplete = widget.match.matchStatus.toLowerCase() == 'complete';

    // Normalize winner reference to one of the team objects if ids match
    if (widget.match.winnerTeam != null) {
      if (widget.match.winnerTeam!.id == widget.match.teamOne.id) {
        _selectedWinner = widget.match.teamOne;
      } else if (widget.match.winnerTeam!.id == widget.match.teamTwo.id) {
        _selectedWinner = widget.match.teamTwo;
      } else {
        _selectedWinner = widget.match.winnerTeam;
      }
    } else {
      _selectedWinner = null;
    }

    // Fetch available leagues
    _fetchAvailableLeagues();
  }

  @override
  void dispose() {
    _arenaController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  Future<void> _fetchAvailableLeagues() async {
    setState(() => _isLoadingLeagues = true);

    final result = await _repository.getAllLeagues();
    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load leagues: ${failure.message}'),
            ),
          );
        }
      },
      (success) {
        if (mounted) {
          setState(() {
            _availableLeagues = success.data;
            _isLoadingLeagues = false;
          });
        }
      },
    );
  }

  Future<void> _saveMatchUpdates() async {
    setState(() => _isSaving = true);

    // Build update payload with only changed fields
    final updates = <String, dynamic>{};

    // Update arena/venue
    if (_arenaController.text != widget.match.venueName) {
      updates['matchVenue'] = {'name': _arenaController.text};
    }

    // Update match date/time
    if (_selectedDateTime != widget.match.matchDateTime) {
      updates['matchDateTime'] = _selectedDateTime.toIso8601String();
    }

    // Update league if changed
    if (_selectedLeagueId != null &&
        _selectedLeagueId != widget.match.leagueId) {
      updates['league'] = _selectedLeagueId;
    }

    // Update score (convert score text to sets structure)
    final scoreText = _scoreController.text.trim();
    if (scoreText != widget.match.formattedScore()) {
      final cleaned = scoreText.replaceAll(' ', '');
      final parts = cleaned.split('-');
      if (parts.length == 2) {
        final team1Sets = int.tryParse(parts[0]) ?? 0;
        final team2Sets = int.tryParse(parts[1]) ?? 0;

        final sets = <Map<String, dynamic>>[];
        for (var i = 0; i < team1Sets; i++) {
          sets.add({'teamOneGames': 1, 'teamTwoGames': 0});
        }
        for (var i = 0; i < team2Sets; i++) {
          sets.add({'teamOneGames': 0, 'teamTwoGames': 1});
        }

        updates['matchScore'] = {'sets': sets};
      }
    }

    // Update winner
    if (_selectedWinner != null &&
        _selectedWinner!.id != widget.match.winnerTeam?.id) {
      updates['winnerTeam'] = _selectedWinner!.id;
    }

    // Update match status (complete or not)
    final currentStatus = widget.match.matchStatus.toLowerCase();
    final newStatus = _isMatchComplete ? 'completed' : 'live';
    if (currentStatus != newStatus) {
      updates['matchStatus'] = newStatus;
    }

    if (updates.isEmpty) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No changes to save')));
      return;
    }

    final result = await _repository.updateMatch(widget.match.id, updates);

    result.fold(
      (failure) {
        if (mounted) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update match: ${failure.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      (success) {
        if (mounted) {
          setState(() => _isSaving = false);

          // Update local match object with new values
          widget.match.venueName = _arenaController.text;
          widget.match.matchDateTime = _selectedDateTime;
          widget.match.updateScore(_scoreController.text);
          widget.match.leagueName = _selectedLeague ?? widget.match.leagueName;
          widget.match.winnerTeam = _selectedWinner;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Match updated successfully'),
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
    return Card(
      color: AppColors.leagueBackgroundGrey,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 0,
                bottom: 12,
              ),
              child: Container(height: 2, color: AppColors.gray),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: _isEditing
                      ? EdgeInsetsGeometry.only(
                          left: screenWidth / 2 - 50,
                          bottom: 8,
                        )
                      : EdgeInsetsGeometry.only(
                          left: screenWidth / 2 - 40,
                          bottom: 8,
                        ),
                  child: Text(
                    _isEditing ? "Edit Match" : "Match",
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : IconButton(
                        icon: Image(
                          height: 22,
                          width: 22,
                          image: AssetImage("assets/images/edit_icon.png"),
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          if (_isEditing) {
                            // Save changes via API
                            await _saveMatchUpdates();
                            setState(() => _isEditing = false);
                          } else {
                            setState(() => _isEditing = true);
                          }
                        },
                      ),
              ],
            ),

            // 🔹 Teams & Date/Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTeamDisplay(
                  widget.match.teamOne.logoPhotoUrl,
                  widget.match.teamOne.teamName,
                ),
                _isEditing
                    ? Column(
                        children: [
                          TextButton(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _selectedDateTime,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                    _selectedDateTime,
                                  ),
                                );
                                if (time != null) {
                                  setState(() {
                                    _selectedDateTime = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      time.hour,
                                      time.minute,
                                    );
                                  });
                                }
                              }
                            },
                            child: Column(
                              children: [
                                Text(
                                  DateFormat(
                                    "MMM d y",
                                  ).format(_selectedDateTime),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  DateFormat("H:mm").format(_selectedDateTime),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Text(
                            DateFormat.yMMMd().format(_selectedDateTime),
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            DateFormat.Hm().format(_selectedDateTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                _buildTeamDisplay(
                  widget.match.teamTwo.logoPhotoUrl,
                  widget.match.teamTwo.teamName,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔹 Details
            const Text(
              'Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _isEditing
                  ? _isLoadingLeagues
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : DropdownButtonFormField<String>(
                            dropdownColor: Colors.black87,
                            value: _selectedLeagueId,
                            items: _availableLeagues
                                .map(
                                  (league) => DropdownMenuItem<String>(
                                    value: league.id,
                                    child: Text(
                                      league.leagueName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedLeagueId = value;
                                // Update display name
                                _selectedLeague = _availableLeagues
                                    .firstWhere((l) => l.id == value)
                                    .leagueName;
                              });
                            },
                            decoration: _inputDecoration("League"),
                            style: const TextStyle(color: Colors.white),
                          )
                  : _buildDetailRow(
                      "assets/images/group_logo.png",
                      'League',
                      widget.match.leagueName,
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _isEditing
                  ? TextFormField(
                      controller: _arenaController,
                      decoration: _inputDecoration("Arena"),
                      style: const TextStyle(color: Colors.white),
                    )
                  : _buildDetailRow(
                      "assets/images/group_icon.png",
                      'Arena',
                      widget.match.venueName,
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _isEditing
                  ? TextFormField(
                      controller: _scoreController,
                      decoration: _inputDecoration("Score"),
                      style: const TextStyle(color: Colors.white),
                    )
                  : _buildDetailRow(
                      "assets/images/score_icon.png",
                      'Score',
                      widget.match.formattedScore(),
                    ),
            ),

            _isEditing
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: DropdownButtonFormField<Team?>(
                      dropdownColor: Colors.black87,
                      initialValue: _selectedWinner,
                      items: [widget.match.teamOne, widget.match.teamTwo]
                          .map(
                            (t) => DropdownMenuItem<Team?>(
                              value: t,
                              child: Text(
                                t.teamName,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _selectedWinner = val),
                      decoration: _inputDecoration('Winner'),
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : _buildDetailRow(
                    "assets/images/winner_icon.png",
                    'Winner',
                    widget.match.winnerTeam?.teamName ?? 'TBD',
                  ),

            // Match Complete Checkbox (only in edit mode)
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: CheckboxListTile(
                  title: const Text(
                    'Is match complete?',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: _isMatchComplete,
                  onChanged: (bool? value) {
                    setState(() {
                      _isMatchComplete = value ?? false;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      ),
    );
  }

  Widget _buildTeamDisplay(String logoPath, String name) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: (logoPath.startsWith('http') || logoPath.startsWith('https'))
              ? Image.network(
                  logoPath,
                  width: 40,
                  height: 40,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, color: Colors.white),
                )
              : Image.asset(logoPath, width: 40, height: 40),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildDetailRow(String images, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Image(height: 18, width: 18, image: AssetImage(images)),
          const SizedBox(width: 20),
          Text(
            '$label:',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
