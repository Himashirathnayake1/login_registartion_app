import 'package:vampire_designs/core/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('email', () {
    expect(Validators.email('a@b.com'), isNull);
    expect(Validators.email('bad'), isNotNull);
    expect(Validators.email(''), isNotNull);
  });
  test('mobile', () {
    expect(Validators.mobile('9876543210'), isNull);
    expect(Validators.mobile('123'), isNotNull);
  });
  test('emailOrMobile', () {
    expect(Validators.emailOrMobile('a@b.com'), isNull);
    expect(Validators.emailOrMobile('9876543210'), isNull);
    expect(Validators.emailOrMobile('a@'), isNotNull);
  });
  test('strongPassword', () {
    expect(Validators.strongPassword('Password1'), isNull);
    expect(Validators.strongPassword('password'), isNotNull);
    expect(Validators.strongPassword('Short1'), isNotNull);
  });
  test('confirmPassword', () {
    final v = Validators.confirmPassword(() => 'Password1');
    expect(v('Password1'), isNull);
    expect(v('Other'), isNotNull);
  });
}
