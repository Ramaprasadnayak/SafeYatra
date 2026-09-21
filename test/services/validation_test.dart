import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Email Validation', () {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    test('Valid emails pass validation', () {
      expect(emailRegex.hasMatch('user@example.com'), isTrue);
      expect(emailRegex.hasMatch('test.user@domain.co.in'), isTrue);
      expect(emailRegex.hasMatch('user123@test-domain.com'), isTrue);
    });

    test('Invalid emails fail validation', () {
      expect(emailRegex.hasMatch('invalid'), isFalse);
      expect(emailRegex.hasMatch('@example.com'), isFalse);
      expect(emailRegex.hasMatch('user@'), isFalse);
      expect(emailRegex.hasMatch('user@.com'), isFalse);
      expect(emailRegex.hasMatch(''), isFalse);
    });
  });

  group('Password Validation', () {
    test('Password length validation', () {
      expect('12345'.length >= 6, isFalse);
      expect('123456'.length >= 6, isTrue);
      expect('password123'.length >= 8, isTrue);
      expect('short'.length >= 8, isFalse);
    });
  });

  group('Username Validation', () {
    test('Username length validation', () {
      expect('ab'.length >= 3, isFalse);
      expect('abc'.length >= 3, isTrue);
      expect('validuser'.length >= 3, isTrue);
    });

    test('Username trimming', () {
      expect('  user  '.trim(), equals('user'));
      expect('user'.trim().length >= 3, isTrue);
      expect('  ab  '.trim().length >= 3, isFalse);
    });
  });
}
