import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_result.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._service);

  static const _rememberKey = 'remember_identifier';

  final AuthService _service;

  bool _isLoading = false;
  bool _rememberMe = false;
  UserModel? _currentUser;

  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;
  UserModel? get currentUser => _currentUser;

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }


  Future<String?> loadRemembered() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_rememberKey);
      _rememberMe = saved != null;
      notifyListeners();
      return saved;
    } catch (_) {
      return null; 
    }
  }

  Future<AuthResult> login(String identifier, String password) {
    return _run(() async {
      final user = await _service.login(
          identifier: identifier.trim(), password: password);
      _currentUser = user;
      await _persistRemember(identifier.trim());
      return AuthResult.success('Welcome back, ${user.fullName}!', user: user);
    });
  }

  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String mobile,
    required String password,
  }) {
    return _run(() async {
      final user = await _service.register(
        fullName: fullName.trim(),
        email: email.trim(),
        mobile: mobile.replaceAll(RegExp(r'[\s-]'), ''),
        password: password,
      );
      return AuthResult.success(
        'Your account has been created. You can now log in.',
        user: user,
      );
    });
  }

  Future<AuthResult> forgotPassword(String email) {
    return _run(() async {
      await _service.sendPasswordReset(email.trim());
      return AuthResult.success(
          'A password reset link has been sent to ${email.trim()}.');
    });
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> _persistRemember(String identifier) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setString(_rememberKey, identifier);
      } else {
        await prefs.remove(_rememberKey);
      }
    } catch (_) {/* non-critical */}
  }


  Future<AuthResult> _run(Future<AuthResult> Function() action) async {
    _isLoading = true;
    notifyListeners();
    try {
      return await action();
    } on AuthException catch (e) {
      return AuthResult.failure(e.message);
    } catch (_) {
      return const AuthResult.failure(
          'An unexpected error occurred. Please try again.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
