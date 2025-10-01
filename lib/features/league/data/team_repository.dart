import '../../../core/network/network_result.dart';

abstract class TeamRepository {
  // NetworkResult is already a Future<Either<...>>. Returning
  // NetworkResult<Map<String, dynamic>> avoids a Future<Future<...>>
  // and lets callers `await` the result and then `fold` the Either.
  NetworkResult<Map<String, dynamic>> deleteTeam(String id);
}
