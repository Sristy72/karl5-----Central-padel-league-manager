import '../../../core/network/network_result.dart';
import '../models/league_model.dart';
import '../models/match_model.dart';
import '../models/standing_model.dart';

abstract class LeagueRepository {
  NetworkResult<List<League>> getAllLeagues();
  NetworkResult<List<Match>> getMatchesByLeague(String leagueId);
  NetworkResult<List<Standing>> getStandingsAll();
  NetworkResult<Map<String, dynamic>> updateMatch(
    String matchId,
    Map<String, dynamic> updates,
  );
  NetworkResult<Map<String, dynamic>> updateStanding(
    String standingId,
    Map<String, dynamic> updates,
  );
}
