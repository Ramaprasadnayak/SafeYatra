class EmailValidator {
  static final RegExp _emailRegex =
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static bool isValid(String email) {
    return _emailRegex.hasMatch(email);
  }

  static String normalize(String email) {
    return email.trim().toLowerCase();
  }
}
