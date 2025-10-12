import 'dart:io';
import '../../../core/network/network_result.dart';
import 'models/create_league_response_model.dart';
import 'models/create_league_request_model.dart';

abstract class CreateLeagueRepository {
  NetworkResult<CreateLeagueResponseModel> createLeague(
    CreateLeagueRequestModel request, {
    File? logoFile,
    File? bannerFile,
  });
  NetworkResult<CreateLeagueResponseModel> getLeagueById(String id);
}
