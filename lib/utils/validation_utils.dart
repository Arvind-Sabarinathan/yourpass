class ValidationUtils {
  static final _uppercaseRegex = RegExp(r'[A-Z]');
  static final _lowercaseRegex = RegExp(r'[a-z]');
  static final _numberRegex = RegExp(r'[0-9]');
  static final _specialRegex = RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|<>,.?/]');

  static String? validateMasterPassword({
    required String password,
    required String confirmPassword,
  }) {
    if (password.isEmpty) {
      return 'Master password is required';
    }

    if (password.length < 12) {
      return 'Password must be at least 12 characters long';
    }

    if (password.length > 128) {
      return 'Password is too long';
    }

    if (password.contains(' ')) {
      return 'Password must not contain spaces';
    }

    if (RegExp(r'(.)\1{5,}').hasMatch(password)) {
      return 'Password must not contain repeated characters';
    }

    if (_hasSequentialChars(password)) {
      return 'Password must not contain sequential characters';
    }

    if (!_uppercaseRegex.hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!_lowercaseRegex.hasMatch(password)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!_numberRegex.hasMatch(password)) {
      return 'Password must contain at least one number';
    }

    if (!_specialRegex.hasMatch(password)) {
      return 'Password must contain at least one special character';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  static bool _hasSequentialChars(String password) {
    const forwardSequences =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    const reverseSequences =
        'zyxwvutsrqponmlkjihgfedcbaZYXWVUTSRQPONMLKJIHGFEDCBA9876543210';

    final lower = password.toLowerCase();

    for (int len = 4; len >= 3; len--) {
      if (lower.length < len) continue;
      for (int i = 0; i <= lower.length - len; i++) {
        final substr = lower.substring(i, i + len);
        if (forwardSequences.contains(substr) ||
            reverseSequences.contains(substr)) {
          return true;
        }
      }
    }
    return false;
  }
}
