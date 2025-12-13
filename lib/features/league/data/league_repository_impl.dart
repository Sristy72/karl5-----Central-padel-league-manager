import '../../../core/network/api_client.dart';
import '../../../core/network/constants/api_constants.dart';
import '../../../core/network/network_result.dart';
import '../models/league_model.dart';
import '../models/match_model.dart';
import '../models/standing_model.dart';
import 'league_repository.dart';

class LeagueRepositoryImpl implements LeagueRepository {
  final ApiClient _apiClient;

  LeagueRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<List<League>> getAllLeagues() {
    final endpoint = '${ApiConstants.baseUrl}/league/all-league';
    return _apiClient.get<List<League>>(
      endpoint,
      fromJsonT: (json) =>
          (json as List).map((item) => League.fromJson(item)).toList(),
    );
  }

  @override
  NetworkResult<List<Match>> getMatchesByLeague(String leagueId) {
    // full endpoint: {baseUrl}/match/all-match
    final endpoint = '${ApiConstants.baseUrl}/match/all-match';
    return _apiClient.get<List<Match>>(
      endpoint,
      fromJsonT: (json) {
        final list = (json as List)
            .map((e) => Match.fromJson(e as Map<String, dynamic>))
            .toList();
        // Try to filter by nested league id if present on match json
        return list;
      },
    );
  }

  @override
  NetworkResult<List<Standing>> getStandingsAll() {
    final endpoint = '${ApiConstants.baseUrl}/standing/all';
    return _apiClient.get<List<Standing>>(
      endpoint,
      fromJsonT: (json) => (json as List)
          .map((e) => Standing.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  NetworkResult<Map<String, dynamic>> updateMatch(
    String matchId,
    Map<String, dynamic> updates,
  ) {
    final endpoint = '${ApiConstants.baseUrl}/match/$matchId';
    return _apiClient.patch<Map<String, dynamic>>(
      endpoint,
      data: updates,
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
  }

  @override
  NetworkResult<Map<String, dynamic>> updateStanding(
    String standingId,
    Map<String, dynamic> updates,
  ) {
    final endpoint = '${ApiConstants.baseUrl}/standing/$standingId';
    return _apiClient.patch<Map<String, dynamic>>(
      endpoint,
      data: updates,
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
  }
}
