import '../../../../core/network/network_result.dart';

abstract class TeamConfirmationRepository {
  // NetworkResult is already a Future<Either<...>>; return it directly to avoid a
  // double-wrapped Future (Future<NetworkResult<...>>).
  NetworkResult<Map<String, dynamic>> updateTeamStatus(
    String id,
    String status,
  );

  NetworkResult<Map<String, dynamic>> deleteTeam(String id);
}
