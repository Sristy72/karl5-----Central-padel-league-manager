class CreateLeagueResponseModel {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  CreateLeagueResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CreateLeagueResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateLeagueResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>? ?? {},
    );
  }
}
