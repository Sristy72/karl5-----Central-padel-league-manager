import 'user_model.dart';

class AuthResponseData {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  AuthResponseData({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponseData.fromJson(Map<String, dynamic> json) {
    // Handle both login response (user field) and register response (result field)
    final userJson = json['user'] ?? json['result'];

    return AuthResponseData(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: UserModel.fromJson(userJson as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }
}
