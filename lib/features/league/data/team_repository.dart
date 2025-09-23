import '../../../core/network/network_result.dart';

abstract class TeamRepository {
  NetworkResult<Map<String, dynamic>> deleteTeam(String id);
}
