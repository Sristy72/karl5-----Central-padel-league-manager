import 'package:flutter_karlfive223_manager/core/network/api_client.dart';
import 'package:flutter_karlfive223_manager/core/network/constants/api_constants.dart';
import 'package:flutter_karlfive223_manager/core/network/network_result.dart';
import '../../domain/repo/team_confirmation_repo.dart';

class TeamConfirmationRepositoryImpl implements TeamConfirmationRepository {
  final ApiClient _apiClient;

  TeamConfirmationRepositoryImpl(this._apiClient);

  @override
  NetworkResult<Map<String, dynamic>> updateTeamStatus(
    String id,
    String status,
  ) {
    final endpoint1 = '${ApiConstants.baseUrl}/team/update-status/$id';
    // The backend may expose update-status OR accept patch on the resource itself.
    // Try the explicit update-status endpoint first, then fall back to PATCH /team/:id.
    return (() async {
      final res1 = await _apiClient.patch<Map<String, dynamic>>(
        endpoint1,
        data: {'applicationStatus': status},
        fromJsonT: (json) => json as Map<String, dynamic>,
      );

      // If the server returned a left (failure) and it looks like API not found,
      // try the alternative endpoint.
      if (res1.isLeft()) {
        final failure = res1.fold((l) => l, (_) => null);
        final msg = (failure?.message ?? '').toLowerCase();
        if (msg.contains('api not found') || failure?.statusCode == 404) {
          final endpoint2 = '${ApiConstants.baseUrl}/team/$id';
          return await _apiClient.patch<Map<String, dynamic>>(
            endpoint2,
            data: {'applicationStatus': status},
            fromJsonT: (json) => json as Map<String, dynamic>,
          );
        }
      }

      return res1;
    })();
  }

  @override
  NetworkResult<Map<String, dynamic>> deleteTeam(String id) {
    final endpoint = '${ApiConstants.baseUrl}/team/$id';
    return _apiClient.delete<Map<String, dynamic>>(
      endpoint,
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
  }
}
