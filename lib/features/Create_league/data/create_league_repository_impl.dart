import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import '../../../core/network/api_client.dart';
import '../../../core/network/constants/api_constants.dart';
import '../../../core/network/network_result.dart';
import 'create_league_repository.dart';
import 'models/create_league_request_model.dart';
import 'models/create_league_response_model.dart';
import 'dart:convert';

import 'models/league_model.dart';

class CreateLeagueRepositoryImpl implements CreateLeagueRepository {
  final ApiClient _apiClient;

  CreateLeagueRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  NetworkResult<LeagueModel> createLeague(
      CreateLeagueRequestModel request, {
        File? logoFile,
        File? bannerFile,
      }) async {
    try {
      final formData = FormData();

      // Text fields (match Postman one-to-one)
      formData.fields.addAll([
        MapEntry('user', request.user),
        MapEntry('leagueName', request.leagueName),
        MapEntry('description', request.description),
        MapEntry('startDate', request.startDate),
        MapEntry('location', request.location),
        MapEntry('addTeam', ''),
        MapEntry('type', request.type),
        MapEntry('matchFormat', request.matchFormat),
        MapEntry('tiebreakOption', request.tiebreakOption),
        MapEntry('allowSubstitutes', request.allowSubstitutes.toString()),
        MapEntry('totalGameWeeks', request.totalGameWeeks.toString()),
        MapEntry('price', request.price ?? ''),

      ]);

      // Logo (file)
      if (logoFile != null) {
        final filename = path.basename(logoFile.path);
        formData.files.add(
          MapEntry(
            'logo',
            await MultipartFile.fromFile(logoFile.path, filename: filename),
          ),
        );
      }

      // Banner (optional file)
      if (bannerFile != null) {
        final filename = path.basename(bannerFile.path);
        formData.files.add(
          MapEntry(
            'banner',
            await MultipartFile.fromFile(bannerFile.path, filename: filename),
          ),
        );
      }

      // Send as multipart/form-data
      return _apiClient.postFormData<LeagueModel>(
        '${ApiConstants.baseUrl}/league/create',
        formData: formData,
        fromJsonT: (json) => LeagueModel.fromJson(json as Map<String, dynamic>),
      );

    } catch (e, st) {
      if (kDebugMode) print("createLeague error: $e\n$st");
      rethrow;
    }
  }



  @override
  NetworkResult<LeagueModel> getLeagueById(String id) {
    return _apiClient.get<LeagueModel>(
      '${ApiConstants.baseUrl}/league/$id',
      fromJsonT: (json) => LeagueModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
