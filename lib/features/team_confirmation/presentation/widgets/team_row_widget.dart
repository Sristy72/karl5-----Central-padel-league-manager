import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../league/models/team_model.dart';
import '../../domain/repo/team_confirmation_repo.dart';
import '../../data/repo/team_confirmation_repoImpl.dart';

class TeamRowWidget extends StatefulWidget {
  final Team team;
  final VoidCallback? onDeleted;
  final ValueChanged<String>? onStatusUpdated;

  const TeamRowWidget({
    super.key,
    required this.team,
    this.onDeleted,
    this.onStatusUpdated,
  });

  @override
  State<TeamRowWidget> createState() => _TeamRowWidgetState();
}

class _TeamRowWidgetState extends State<TeamRowWidget> {
  late final TeamConfirmationRepository _repo;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final apiClient = Get.find<ApiClient>();
    _repo = TeamConfirmationRepositoryImpl(apiClient);
  }

  Future<void> _handleApprove() async {
    setState(() => _isLoading = true);
    try {
      final result = await _repo.updateTeamStatus(widget.team.id, 'approved');
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Approval failed: ${failure.message}')),
          );
        },
        (success) {
          widget.onStatusUpdated?.call('approved');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Team approved successfully')),
          );
        },
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleReject() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Team'),
        content: const Text('Are you sure you want to reject this team?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Reject'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final result = await _repo.deleteTeam(widget.team.id);
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Rejection failed: ${failure.message}')),
          );
        },
        (success) {
          widget.onDeleted?.call();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Team rejected successfully')),
          );
        },
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
                      widget.team.teamName,
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
                "${widget.team.captainName}-${widget.team.partnerName}",
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
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: AppColors.white,
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                minimumSize: const Size(70, 32),
                              ),
                              onPressed: () {
                                // TODO: View details
                              },
                              child: const Text("View details"),
                            ),
                            const SizedBox(width: 4),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: AppColors.white,
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                minimumSize: const Size(70, 32),
                              ),
                              onPressed: _handleApprove,
                              child: const Text("Approve"),
                            ),
                            const SizedBox(width: 4),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: AppColors.white,
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                minimumSize: const Size(70, 32),
                              ),
                              onPressed: _handleReject,
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
