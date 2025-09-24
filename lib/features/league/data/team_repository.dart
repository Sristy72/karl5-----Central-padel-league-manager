import '../../../core/network/network_result.dart';

abstract class TeamRepository {
  Future<NetworkResult<Map<String, dynamic>>> deleteTeam(String id);
}
