import 'user_model.dart';

/// Uniform result returned by the controller to the UI.
class AuthResult {
  final bool success;
  final String message;
  final UserModel? user;

  const AuthResult.success(this.message, {this.user}) : success = true;
  const AuthResult.failure(this.message)
      : success = false,
        user = null;
}
