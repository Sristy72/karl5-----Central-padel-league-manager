import '../../../core/network/api_client.dart';
import '../../../core/network/constants/api_constants.dart';
import '../../../core/network/network_result.dart';
import '../domain/repo/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  final ApiClient _apiClient;

  TeamRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<Map<String, dynamic>> deleteTeam(String id) {
    final endpoint = '${ApiConstants.baseUrl}/team/$id';
    return _apiClient.delete<Map<String, dynamic>>(
      endpoint,
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
  }
}
