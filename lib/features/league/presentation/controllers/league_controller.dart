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
          final raw = success.data as Map<String, dynamic>;
          final data = raw['data'] as List<dynamic>? ?? [];
          final meta = raw['meta'] as Map<String, dynamic>?;

          final fetched = data.map((e) => League.fromJson(e)).toList();

          if (refresh) {
            leagues.assignAll(fetched);
          } else {
            leagues.addAll(fetched);
          }

          if (meta != null) {
            total.value = meta['total'] as int? ?? total.value;
          }

          // if there are more pages, increment page
          if (leagues.length < total.value) {
            page++;
          }
        } catch (e) {
          errorMessage('Failed to parse leagues');
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
