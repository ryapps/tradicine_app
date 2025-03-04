class ReqLoginModel {
  final String grantType;
  final String clientId;
  final String clientSecret;
  final String? email;
  final String? password;
  final String? refreshToken;

  ReqLoginModel({
    required this.grantType,
    required this.clientId,
    required this.clientSecret,
    this.email,
    this.password,
    this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    return {
      "grant_type": grantType,
      "client_id": clientId,
      "client_secret": clientSecret,
      "email": email,
      "password": password,
      "refresh_token": refreshToken,
    };
  }
}
