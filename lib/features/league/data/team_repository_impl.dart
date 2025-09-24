import '../../../core/network/api_client.dart';
import '../../../core/network/constants/api_constants.dart';
import 'package:dio/dio.dart';
import '../../../core/network/network_result.dart';
import '../../../core/network/services/secure_store_services.dart';
import '../../../core/network/constants/key_constants.dart';
import 'package:flutx_core/flutx_core.dart';
import 'team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  final ApiClient _apiClient;

  TeamRepositoryImpl({required ApiClient apiclient}) : _apiClient = apiclient;

  @override
  NetworkResult<Map<String, dynamic>> deleteTeam(String id) async {
    final endpoint = '${ApiConstants.baseUrl}/team/$id';
    
    //! <--- Debug: log token and endpoint to help diagnose auth issues
    try {
      final token = await SecureStoreServices().retrieveData(
        KeyConstants.accessToken,
      );
      DPrint.log(
        '>>> Attempting DELETE TEAM for id=$id endpoint=$endpoint token=$token',
      );
    } catch (e) {
      DPrint.log('ERROR : Could not read token for debug: $e');
    }

    // Defensive: if token is available, pass it explicitly in options
    try {
      final token = await SecureStoreServices().retrieveData(
        KeyConstants.accessToken,
      );
      if (token != null && token.isNotEmpty) {
        final options = Options(headers: ApiConstants.authHeaders(token));
        return await _apiClient.delete<Map<String, dynamic>>(
          endpoint,
          fromJsonT: (json) => json as Map<String, dynamic>,
          options: options,
        );
      }
    } catch (e) {
      DPrint.log('ERROR : Could not read token for explicit header: $e');
    }

    return await _apiClient.delete<Map<String, dynamic>>(
      endpoint,
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
  }
}
