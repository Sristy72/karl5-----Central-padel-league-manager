import '../../../../core/network/network_result.dart';

abstract class TeamConfirmationRepository {
  Future<NetworkResult<Map<String, dynamic>>> updateTeamStatus(
    String id,
    String status,
  );
  Future<NetworkResult<Map<String, dynamic>>> deleteTeam(String id);
}
