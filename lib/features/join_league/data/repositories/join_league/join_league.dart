import 'package:dio/dio.dart';


import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/constants/api_constants.dart';
import '../../../../../core/network/network_result.dart';
import '../../../domain/repo/team_repo.dart';

import '../../model/join_response_model.dart';
import '../../model/league_reponse_model.dart';

class JoinLeagueRepositoryImpl implements JoinLeagueRepository {
  final ApiClient _apiClient;

  JoinLeagueRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  NetworkResult<JoinResponseModel> createTeam(FormData formData) {
    return _apiClient.post<JoinResponseModel>(
      ApiConstants.team.create,
      data: formData,
      fromJsonT: (json) => JoinResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<List<LeagueResponeModel>> getAllLeague() {
    return _apiClient.get<List<LeagueResponeModel>>(
      ApiConstants.league.getAllLeagues,
      fromJsonT: (json) => (json as List)
          .map((item) => LeagueResponeModel.fromJson(item))
          .toList(),
    );
  }
}
