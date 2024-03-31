class Validators {
  static String? isValidEmail(String? email) {
    final regx = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (email == null) {
      return null;
    }
    if (regx.hasMatch(email)) {
      return null;
    }
    return "Email is invalid";
  }

  static String? isValidPassword(String? password, {String? confirmPassword}) {
    if (confirmPassword != null) {
      if (password != confirmPassword) {
        return 'Password does not match';
      }
    }
    if (password == null) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
