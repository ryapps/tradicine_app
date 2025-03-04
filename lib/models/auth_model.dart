import 'user_model.dart';

class AuthModel {
  final bool success;
  final String? errorMessage;
  final UserModel? user;

  AuthModel({required this.success, this.errorMessage, this.user});

  factory AuthModel.success(UserModel user) {
    return AuthModel(success: true, user: user);
  }

  factory AuthModel.error(String message) {
    return AuthModel(success: false, errorMessage: message);
  }
}
