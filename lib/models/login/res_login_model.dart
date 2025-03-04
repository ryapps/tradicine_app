import 'package:tradicine_app/models/user_model.dart';

class LoginResponse {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final String? refreshToken;
  final UserModel user;

  LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    this.refreshToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json["access_token"],
      tokenType: json["token_type"],
      expiresIn: json["expires_in"],
      refreshToken: json["refresh_token"],
      user: UserModel.fromJson(json["user"]),
    );
  }
}
