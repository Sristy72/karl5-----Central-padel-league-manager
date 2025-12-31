// features/league/presentation/controllers/league_controller.dart

import 'package:get/get.dart';
import 'package:dartz/dartz.dart';

import '../../data/league_repository.dart';
import '../../models/league_model.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';

class LeagueController extends GetxController {
  final LeagueRepository repository;

  LeagueController({required this.repository});

  var leagues = <League>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  // Pagination
  var page = 1;
  // Use paginated requests (10 per page) — controller will request next pages
  final int limit = 10;
  var total = 0.obs;
  var isFetchingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeagues(refresh: true);
  }

  /// Fetch leagues. Use [refresh] to reset pagination.
  void fetchLeagues({bool refresh = false}) async {
    try {
      if (refresh) {
        isLoading(true);
        errorMessage('');
        page = 1;
        total.value = 0;
        leagues.clear();
      } else {
        isFetchingMore(true);
      }

      final result = await repository.getLeaguesPaged(page: page, limit: limit);

      result.fold((failure) {
        errorMessage(failure.message);
      }, (success) {
        try {
          final fetched = success.data ?? <League>[];

          if (refresh) {
            leagues.assignAll(fetched);
          } else {
            leagues.addAll(fetched);
          }

          // If we received a full page, assume there may be more pages.
          // Otherwise we've reached the end.
          if (fetched.length == limit) {
            page++;
          } else {
            // no more pages — set total to current count to prevent further requests
            total.value = leagues.length;
          }
        } catch (e) {
          errorMessage('Failed to parse leagues: $e');
        }
      });
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
      isFetchingMore(false);
    }
  }

  /// Load next page if available
  void fetchNextPage() {
    if (isLoading.value || isFetchingMore.value) return;
    if (total.value != 0 && leagues.length >= total.value) return;
    fetchLeagues(refresh: false);
  }
}
