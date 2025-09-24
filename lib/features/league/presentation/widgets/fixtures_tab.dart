import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/data/home_repository.dart';
import '../../models/match_model.dart';

class FixturesTab extends StatefulWidget {
  final List<Match> matches;
  final Function(Match match)? onRemove; // optional callback for removing

  const FixturesTab({super.key, required this.matches, this.onRemove});

  @override
  State<FixturesTab> createState() => _FixturesTabState();
}

class _FixturesTabState extends State<FixturesTab> {
  bool _isEditing = false;
  late HomeRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = Get.find<HomeRepository>();
  }

  //* Group matches by Date
  Map<String, List<Match>> _groupByDate(List<Match> input) {
    final map = <String, List<Match>>{};
    for (final m in input) {
      final key = DateFormat('yyyy-MM-dd').format(m.matchDateTime.toLocal());
      map.putIfAbsent(key, () => []).add(m);
    }
    //* Keep the map sorted by date ascending
    final sortedKeys = map.keys.toList()..sort();
    return {for (var k in sortedKeys) k: map[k]!};
  }

  Future<void> _deleteMatch(Match match) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Delete Fixture', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete the match between ${match.teamOne.teamName} vs ${match.teamTwo.teamName}?',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final result = await _repository.deleteMatch(match.id);
      result.fold(
        (failure) {
          // Show error message
          Get.snackbar(
            'Error',
            'Failed to delete fixture: ${failure.message}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
        (success) {
          // Show success message
          Get.snackbar(
            'Success',
            'Fixture deleted successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Call the onRemove callback to update parent widget
          if (widget.onRemove != null) {
            widget.onRemove!(match);
          }
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete fixture: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.matches.isEmpty) {
      return const Center(
        child: Text(
          'No fixtures available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final grouped = _groupByDate(widget.matches);

    return MediaQuery.removePadding(
      context: context,
      removeLeft: true,
      removeRight: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 21,
              right: 21,
              top: 24,
              bottom: 12,
            ),
            child: Container(height: 2, color: AppColors.gray),
          ),

          // Fixtures header with edit button
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Fixtures',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
                    _isEditing = !_isEditing;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          Expanded(
            child: ListView.separated(
              itemCount: grouped.keys.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final dateKey = grouped.keys.elementAt(index);
                final items = grouped[dateKey]!;
                final displayDate = DateFormat(
                  'EEE, d MMM yyyy',
                ).format(DateTime.parse(dateKey));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Text(
                        displayDate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...List.generate(items.length, (i) {
                      final m = items[i];
                      return Container(
                        color: i.isEven ? Colors.black : Colors.grey.shade900,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        child: Row(
                          children: [
                            //* <--- Home team --->
                            Expanded(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage:
                                        m.teamOne.logoPhotoUrl.startsWith(
                                          'http',
                                        )
                                        ? NetworkImage(m.teamOne.logoPhotoUrl)
                                        : const AssetImage(
                                                'assets/images/group_logo.png',
                                              )
                                              as ImageProvider,
                                    backgroundColor: Colors.transparent,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      m.teamOne.teamName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //* <--- Time and score --->
                            Column(
                              children: [
                                Text(
                                  DateFormat(
                                    'hh:mm a',
                                  ).format(m.matchDateTime.toLocal()),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  m.formattedScore(),
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),

                            const SizedBox(width: 12),

                            //* <--- Away team --->
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      m.teamTwo.teamName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage:
                                        m.teamTwo.logoPhotoUrl.startsWith(
                                          'http',
                                        )
                                        ? NetworkImage(m.teamTwo.logoPhotoUrl)
                                        : const AssetImage(
                                                'assets/images/group_logo.png',
                                              )
                                              as ImageProvider,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 12),
                            IconButton(
                              icon: _isEditing
                                  ? const Image(
                                      height: 24,
                                      width: 21,
                                      image: AssetImage(
                                        "assets/images/minus_icon.png",
                                      ),
                                    )
                                  : const Image(
                                      height: 21,
                                      width: 21,
                                      image: AssetImage(
                                        "assets/images/star_icon_off.png",
                                      ),
                                    ),
                              onPressed: () {
                                if (_isEditing) {
                                  //* <--- Delete fixture action here
                                  _deleteMatch(m);
                                } else {
                                  //* <--- Favorite Action Here
                                  debugPrint(
                                    "Star tapped for ${m.teamOne.teamName} vs ${m.teamTwo.teamName}",
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
