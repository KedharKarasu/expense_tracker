// File: lib/utils/validators.dart

class Validators {
  // Email validation
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter your email';
    }
    
    // Email regex pattern
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }

  // Password validation
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter your password';
    }
    
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }

  // Name validation
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Please enter your name';
    }
    
    if (name.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    return null;
  }

  // Phone validation (optional)
  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Please enter your phone number';
    }
    
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    
    if (!phoneRegex.hasMatch(phone)) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  // Generic required field validator
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }
}
