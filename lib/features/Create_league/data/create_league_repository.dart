import 'dart:io';
import '../../../core/network/network_result.dart';
import 'models/league_model.dart';
import 'models/create_league_request_model.dart';

abstract class CreateLeagueRepository {
  NetworkResult<LeagueModel> createLeague(
    CreateLeagueRequestModel request, {
    File? logoFile,
    File? bannerFile,
  });
  NetworkResult<LeagueModel> getLeagueById(String id);
}
