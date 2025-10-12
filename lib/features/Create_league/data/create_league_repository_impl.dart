import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import '../../../core/network/api_client.dart';
import '../../../core/network/constants/api_constants.dart';
import '../../../core/network/network_result.dart';
import 'create_league_repository.dart';
import 'models/create_league_request_model.dart';
import 'models/create_league_response_model.dart';
import 'dart:convert';

class CreateLeagueRepositoryImpl implements CreateLeagueRepository {
  final ApiClient _apiClient;

  CreateLeagueRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  NetworkResult<CreateLeagueResponseModel> createLeague(
    CreateLeagueRequestModel request, {
    File? logoFile,
    File? bannerFile,
  }) async {
    try {
      // Build FormData
      final formData = FormData();

      // Add logo file if provided
      if (logoFile != null) {
        final filename = path.basename(logoFile.path);
        formData.files.add(
          MapEntry(
            'logo',
            await MultipartFile.fromFile(logoFile.path, filename: filename),
          ),
        );
      }

      // Add banner file if provided
      if (bannerFile != null) {
        final filename = path.basename(bannerFile.path);
        formData.files.add(
          MapEntry(
            'banner',
            await MultipartFile.fromFile(bannerFile.path, filename: filename),
          ),
        );
      }

      // Add JSON data as a text field
      formData.fields.add(MapEntry('data', jsonEncode(request.toJson())));

      return _apiClient.post<CreateLeagueResponseModel>(
        '${ApiConstants.baseUrl}/league/create',
        data: formData,
        fromJsonT: (json) =>
            CreateLeagueResponseModel.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  NetworkResult<CreateLeagueResponseModel> getLeagueById(String id) {
    return _apiClient.get<CreateLeagueResponseModel>(
      '${ApiConstants.baseUrl}/league/$id',
      fromJsonT: (json) =>
          CreateLeagueResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
