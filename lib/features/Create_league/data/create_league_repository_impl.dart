import '../../../core/network/api_client.dart';
import '../../../core/network/constants/api_constants.dart';
import '../../../core/network/network_result.dart';
import 'create_league_repository.dart';
import 'models/create_league_request_model.dart';
import 'models/create_league_response_model.dart';

class CreateLeagueRepositoryImpl implements CreateLeagueRepository {
  final ApiClient _apiClient;

  CreateLeagueRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<CreateLeagueResponseModel> createLeague(CreateLeagueRequestModel request) {
    return _apiClient.post<CreateLeagueResponseModel>(
      '${ApiConstants.baseUrl}/league/create',
      data: request.toJson(),
      fromJsonT: (json) => CreateLeagueResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<CreateLeagueResponseModel> getLeagueById(String id) {
    return _apiClient.get<CreateLeagueResponseModel>(
      '${ApiConstants.baseUrl}/league/$id',
      fromJsonT: (json) => CreateLeagueResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
