import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../league/models/team_model.dart';
import '../controllers/team_confirmation_controller.dart';

class TeamRowWidget extends GetView<TeamConfirmationController> {
  final Team team;
  final VoidCallback? onDeleted;
  final ValueChanged<String>? onStatusUpdated;

  const TeamRowWidget({
    super.key,
    required this.team,
    this.onDeleted,
    this.onStatusUpdated,
  });

  Future<void> _handleApprove() async {
    await controller.approveTeam(team.id, () {
      onStatusUpdated?.call('approved');
    });

    if (controller.showMessage.value) {
      Get.snackbar(
        controller.message.value.contains('failed') ? 'Error' : 'Success',
        controller.message.value,
        backgroundColor: controller.message.value.contains('failed')
            ? Colors.red
            : Colors.green,
        colorText: Colors.white,
      );
      controller.clearMessage();
    }
  }

  Future<void> _handleReject() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Reject Team'),
        content: const Text('Are you sure you want to reject this team?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await controller.rejectTeam(team.id, () {
      onDeleted?.call();
    });

    if (controller.showMessage.value) {
      Get.snackbar(
        controller.message.value.contains('failed') ? 'Error' : 'Success',
        controller.message.value,
        backgroundColor: controller.message.value.contains('failed')
            ? Colors.red
            : Colors.green,
        colorText: Colors.white,
      );
      controller.clearMessage();
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
                "${team.captainName}-${team.partnerName}",
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
                child: Obx(
                  () => controller.isLoading.value
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
            ),
          ],
        ),
      ),
    );
  }
}
