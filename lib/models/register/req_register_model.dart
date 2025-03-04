class ReqRegisterModel {
  final String name;
  final String email;
  final String password;
  final String role;
  final String? otp;
  final String? verifiedAt;

  ReqRegisterModel({
    required this.name,
    required this.email,
    required this.password,
    this.role = "user",
    this.otp,
    this.verifiedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "role": role,
      "otp": otp,
      "verified_at": verifiedAt,
    };
  }
}
