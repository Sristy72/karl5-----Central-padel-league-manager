import 'dart:io';
import 'package:get/get.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../data/create_league_repository.dart';
import '../../data/models/create_league_request_model.dart';
import '../../../auth/presentation/controller/auth_controller.dart';
import '../../data/models/league_model.dart';
import '../../data/models/create_league_response_model.dart';


class CreateLeagueController extends GetxController {
  final CreateLeagueRepository repository;

  CreateLeagueController({required this.repository});

  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;
  var league = Rxn<LeagueModel>();
  var createdLeague = Rxn<LeagueModel>();

  Future<bool> createLeague(
    CreateLeagueRequestModel request, {
    File? logoFile,
    File? bannerFile,
  }) async {
    isLoading(true);
    errorMessage('');
    successMessage('');

    // Ensure we have an access token before calling protected API
    try {
      final authStorage = Get.find<AuthStorageService>();
      String? token = await authStorage.getAccessToken();

      if (token == null || token.isEmpty) {
        // No access token. Try to refresh using AuthController if possible.
        final refreshToken = await authStorage.getRefreshToken();
        if (refreshToken != null && refreshToken.isNotEmpty) {
          try {
            final authController = Get.find<AuthController>();
            final refreshed = await authController.refreshToken();
            if (refreshed == true) {
              // Re-read stored access token
              token = await authStorage.getAccessToken();
              if (token == null || token.isEmpty) {
                final msg =
                    'Session could not be refreshed. Please login again.';
                errorMessage(msg);
                Get.snackbar(
                  'Authentication required',
                  msg,
                  snackPosition: SnackPosition.BOTTOM,
                );
                isLoading(false);
                return false;
              }
            } else {
              final msg = 'Session expired. Please login again.';
              errorMessage(msg);
              Get.snackbar(
                'Authentication required',
                msg,
                snackPosition: SnackPosition.BOTTOM,
              );
              isLoading(false);
              return false;
            }
          } catch (e) {
            final msg = 'Unable to refresh session. Please login.';
            errorMessage(msg);
            Get.snackbar(
              'Authentication required',
              msg,
              snackPosition: SnackPosition.BOTTOM,
            );
            isLoading(false);
            return false;
          }
        } else {
          final msg = 'You must be logged in to create a league.';
          errorMessage(msg);
          Get.snackbar(
            'Authentication required',
            msg,
            snackPosition: SnackPosition.BOTTOM,
          );
          isLoading(false);
          return false;
        }
      }
    } catch (e) {
      final msg = 'Authentication service unavailable. Please login.';
      errorMessage(msg);
      Get.snackbar(
        'Authentication required',
        msg,
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading(false);
      return false;
    }

    final result = await repository.createLeague(
      request,
      logoFile: logoFile,
      bannerFile: bannerFile,
    );

    return result.fold(
      (failure) {
        errorMessage(failure.message);
        isLoading(false);
        return false;
      },
      (success) {
        successMessage(success.message);
        createdLeague.value = success.data;

        // ✅ Debug: leagueCode print করে confirm করবে
        print("✅ Created League Name: ${createdLeague.value?.leagueName}");
        print("✅ Created League Code: ${createdLeague.value?.leagueCode}");

        isLoading(false);
        return true;
      },
    );
  }

  /// Load league details by id and store in [league]
  Future<bool> loadLeagueById(String id) async {
    isLoading(true);
    errorMessage('');
    successMessage('');
    try {
      final result = await repository.getLeagueById(id);
      return result.fold(
        (failure) {
          errorMessage(failure.message);
          isLoading(false);
          return false;
        },
        (success) {
          league.value = success.data;
          isLoading(false);
          return true;
        },
      );
    } catch (e) {
      errorMessage('Failed to load league');
      isLoading(false);
      return false;
    }
  }
}
