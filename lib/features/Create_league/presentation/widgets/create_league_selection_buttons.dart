import 'package:flutter/material.dart';

class CreateLeagueSelectionButtons extends StatelessWidget {
  final String selectedType;
  final String selectedMatchFormat;
  final String selectedTiebreak;
  final bool allowSubstitutes;
  final Function(String) onTypeChanged;
  final Function(String) onMatchFormatChanged;
  final Function(String) onTiebreakChanged;
  final Function(bool) onAllowSubstitutesChanged;

  const CreateLeagueSelectionButtons({
    super.key,
    required this.selectedType,
    required this.selectedMatchFormat,
    required this.selectedTiebreak,
    required this.allowSubstitutes,
    required this.onTypeChanged,
    required this.onMatchFormatChanged,
    required this.onTiebreakChanged,
    required this.onAllowSubstitutesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Type
        const Text(
          "Type:",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildSelectionButton(
              'Singles',
              selectedType == 'Singles',
                  () => onTypeChanged('Singles'),
            ),
            const SizedBox(width: 7),
            _buildSelectionButton(
              'Doubles',
              selectedType == 'Doubles',
                  () => onTypeChanged('Doubles'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Match Format
        const Text(
          "Match Format:",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildSelectionButton(
              'Best of 3 sets',
              selectedMatchFormat == 'Best of 3 sets',
                  () => onMatchFormatChanged('Best of 3 sets'),
            ),
            const SizedBox(width: 7),
            _buildSelectionButton(
              'Best of 5 sets',
              selectedMatchFormat == 'Best of 5 sets',
                  () => onMatchFormatChanged('Best of 5 sets'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Tiebreak Option
        const Text(
          "Tiebreak Option",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildSelectionButton(
              'Standard 7-point',
              selectedTiebreak == 'Standard 7-point',
                  () => onTiebreakChanged('Standard 7-point'),
            ),
            const SizedBox(width: 7),
            _buildSelectionButton(
              'No tiebreak',
              selectedTiebreak == 'No tiebreak',
                  () => onTiebreakChanged('No tiebreak'),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Allow substitutes
        GestureDetector(
          onTap: () => onAllowSubstitutesChanged(!allowSubstitutes),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: Center(
                  child: Icon(
                    Icons.circle,
                    size: 10,
                    color: allowSubstitutes ? Colors.green : Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Allow players substitutes",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionButton(String text, bool isSelected,
      VoidCallback onPressed) {
    return SizedBox(
      height: 29,
      width: 116,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFF2AAF08) : Colors.black,
          side: isSelected ? null : const BorderSide(color: Color(0xFF2AAF08)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}