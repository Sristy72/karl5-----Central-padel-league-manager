import 'league_model.dart';

class CreateLeagueResponseModel {
  final bool success;
  final String message;
  final LeagueModel? data;

  CreateLeagueResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory CreateLeagueResponseModel.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>?;
    return CreateLeagueResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: dataJson != null ? LeagueModel.fromJson(dataJson) : null,
    );
  }
}
