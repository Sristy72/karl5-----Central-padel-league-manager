import 'package:flutter/material.dart';
import '../../models/match_model.dart';
import '../../models/team_model.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';

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

  // Controllers for editable fields
  late TextEditingController _arenaController;
  late TextEditingController _scoreController;
  late DateTime _selectedDateTime;
  String? _selectedLeague;
  Team? _selectedWinner;

  @override
  void initState() {
    super.initState();
    _arenaController = TextEditingController(text: widget.match.venueName);
    _scoreController = TextEditingController(
      text: widget.match.formattedScore(),
    );
    _selectedDateTime = widget.match.matchDateTime;
    _selectedLeague = widget.match.leagueName;
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
  }

  @override
  void dispose() {
    _arenaController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      color: AppColors.leaguTabsBackground,
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
                      color: AppColors.teamCardBackground,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: Image(
                    height: 22,
                    width: 22,
                    image: AssetImage("assets/images/edit_icon.png"),
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_isEditing) {
                        // Save logic here (API call or state update)
                        widget.match.venueName = _arenaController.text;
                        widget.match.matchDateTime = _selectedDateTime;
                        widget.match.updateScore(_scoreController.text);
                        widget.match.leagueName = _selectedLeague ?? '';
                        // Persist winner selection
                        widget.match.winnerTeam = _selectedWinner;
                      }
                      _isEditing = !_isEditing;
                    });
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
                  ? (() {
                      //! <--- NEED TO ADD API) --->
                      final leagues = [
                        "Premier League",
                        "League 2",
                        "League 3",
                      ];
                      final currentValue = leagues.contains(_selectedLeague)
                          ? _selectedLeague
                          : null;
                      return DropdownButtonFormField<String>(
                        dropdownColor: Colors.black87,
                        initialValue: currentValue,
                        items: leagues
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedLeague = value),
                        decoration: _inputDecoration("League"),
                        style: const TextStyle(color: Colors.white),
                      );
                    }())
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
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<Team?>(
                      dropdownColor: Colors.black87,
                      value: _selectedWinner,
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
            color: AppColors.teamCardBackground,
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
