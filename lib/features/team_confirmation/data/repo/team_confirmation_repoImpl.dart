import 'package:flutter_karlfive223_manager/core/network/api_client.dart';
import 'package:flutter_karlfive223_manager/core/network/constants/api_constants.dart';
import 'package:flutter_karlfive223_manager/core/network/network_result.dart';
import '../../domain/repo/team_confirmation_repo.dart';

class TeamConfirmationRepositoryImpl implements TeamConfirmationRepository {
  final ApiClient _apiClient;

  TeamConfirmationRepositoryImpl(this._apiClient);

  @override
  Future<NetworkResult<Map<String, dynamic>>> updateTeamStatus(
    String id,
    String status,
  ) async {
    final endpoint = '${ApiConstants.baseUrl}/team/update-status/$id';
    return _apiClient.put<Map<String, dynamic>>(
      endpoint,
      data: {'status': status},
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
  }

  @override
  Future<NetworkResult<Map<String, dynamic>>> deleteTeam(String id) async {
    final endpoint = '${ApiConstants.baseUrl}/team/$id';
    return _apiClient.delete<Map<String, dynamic>>(
      endpoint,
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
  }
}
