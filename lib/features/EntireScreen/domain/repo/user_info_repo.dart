import 'package:dio/dio.dart';


import '../../../../core/network/network_result.dart';
import '../../data/model/user_info_response_model.dart';

abstract class UserInfoRepo {
  NetworkResult<UserInfoResponseModel> updateprofile(FormData formData);
}
