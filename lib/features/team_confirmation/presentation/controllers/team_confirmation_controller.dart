import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/repo/team_confirmation_repo.dart';
import '../../data/repo/team_confirmation_repo_impl.dart';

class TeamConfirmationController extends GetxController {
  late final TeamConfirmationRepository _repo;

  final RxBool isLoading = false.obs;
  final RxString message = ''.obs;
  final RxBool showMessage = false.obs;

  @override
  void onInit() {
    super.onInit();
    final apiClient = Get.find<ApiClient>();
    _repo = TeamConfirmationRepositoryImpl(apiClient);
  }

  Future<void> approveTeam(String teamId, VoidCallback? onSuccess) async {
    isLoading.value = true;
    try {
      final either = await _repo.updateTeamStatus(teamId, 'approved');
      either.fold(
        (failure) {
          message.value = 'Approval failed: ${failure.message}';
          showMessage.value = true;
        },
        (success) {
          message.value = 'Team approved successfully';
          showMessage.value = true;
          onSuccess?.call();
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectTeam(String teamId, VoidCallback? onSuccess) async {
    isLoading.value = true;
    try {
      final either = await _repo.deleteTeam(teamId);
      either.fold(
        (failure) {
          message.value = 'Rejection failed: ${failure.message}';
          showMessage.value = true;
        },
        (success) {
          message.value = 'Team rejected successfully';
          showMessage.value = true;
          onSuccess?.call();
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearMessage() {
    showMessage.value = false;
    message.value = '';
  }
}
