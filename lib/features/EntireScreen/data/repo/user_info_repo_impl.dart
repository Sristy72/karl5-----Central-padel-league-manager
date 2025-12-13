import 'package:dio/dio.dart';


import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/repo/user_info_repo.dart';
import '../model/user_info_response_model.dart';

class UserInfoRepoImpl implements UserInfoRepo {
  final ApiClient _apiClient;

  UserInfoRepoImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<UserInfoResponseModel> updateprofile(FormData formData) {
    return _apiClient.put<UserInfoResponseModel>(
      ApiConstants.user.updateProfile,
      data: formData,
      fromJsonT: (json) => UserInfoResponseModel.fromJson(json),
      // isFormData: true
    );
  }
}
