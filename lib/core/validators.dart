class Validators {
  Validators._();

  static final _emailRegex =
      RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
  static final _phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

  static String? fullName(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Full name is required';
    if (value.length < 3) return 'Name must be at least 3 characters';
    if (!RegExp(r"^[A-Za-z][A-Za-z .'-]*$").hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  static String? email(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  static String? mobile(String? v) {
    final value = (v ?? '').replaceAll(RegExp(r'[\s-]'), '');
    if (value.isEmpty) return 'Mobile number is required';
    if (!_phoneRegex.hasMatch(value)) {
      return 'Enter a valid mobile number (10-15 digits)';
    }
    return null;
  }

  static String? emailOrMobile(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Email or mobile number is required';
    return value.contains('@') ? email(value) : mobile(value);
  }


  static String? requiredPassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    return null;
  }


  static String? strongPassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Add at least one uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(v)) return 'Add at least one lowercase letter';
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Add at least one number';
    return null;
  }

  static String? Function(String?) confirmPassword(String Function() original) {
    return (v) {
      if (v == null || v.isEmpty) return 'Please confirm your password';
      if (v != original()) return 'Passwords do not match';
      return null;
    };
  }
}
