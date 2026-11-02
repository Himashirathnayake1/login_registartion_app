import '../models/user_model.dart';

/// Thrown by services for any expected failure
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}

abstract class AuthService {
  Future<UserModel> login({required String identifier, required String password});

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String mobile,
    required String password,
  });

  Future<void> sendPasswordReset(String email);
}

class MockAuthService implements AuthService {
  static const _latency = Duration(milliseconds: 1500);

  final List<_Record> _users = [
    _Record(
      const UserModel(
        id: '1',
        fullName: 'Test User',
        email: 'test@example.com',
        mobile: '9876543210',
      ),
      'Password1',
    ),
  ];

  void _simulateFailures(String value) {
    final v = value.toLowerCase();
    if (v.contains('offline')) {
      throw const AuthException(
          'No internet connection. Please check your network and try again.');
    }
    if (v.contains('server')) {
      throw const AuthException(
          'Something went wrong on our side. Please try again later.');
    }
  }

  @override
  Future<UserModel> login({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(_latency);
    _simulateFailures(identifier);
    final id = identifier.trim().toLowerCase();
    final match = _users.where((r) =>
        (r.user.email.toLowerCase() == id || r.user.mobile == id) &&
        r.password == password);
    if (match.isEmpty) {
      throw const AuthException('Incorrect email/mobile number or password.');
    }
    return match.first.user;
  }

  @override
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String mobile,
    required String password,
  }) async {
    await Future.delayed(_latency);
    _simulateFailures(email);
    final exists = _users.any((r) =>
        r.user.email.toLowerCase() == email.toLowerCase() ||
        r.user.mobile == mobile);
    if (exists) {
      throw const AuthException(
          'An account with this email or mobile number already exists.');
    }
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      email: email,
      mobile: mobile,
    );
    _users.add(_Record(user, password));
    return user;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await Future.delayed(_latency);
    _simulateFailures(email);
    final exists =
        _users.any((r) => r.user.email.toLowerCase() == email.toLowerCase());
    if (!exists) {
      throw const AuthException('No account found with this email address.');
    }
  }
}

class _Record {
  final UserModel user;
  final String password;
  _Record(this.user, this.password);
}
