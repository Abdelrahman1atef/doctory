import 'dart:math';
import 'validation_utils.dart';

/// General helper utilities
class Utils {
  Utils._();

  /// Current language - updated by app
  static String lang = 'ar';

  // ==================== GENERATORS ====================

  /// Generate random barcode
  static String generateBarcode() {
    return (Random().nextInt(99999999) + 10000000).toString();
  }

  /// Generate unique ID
  static String generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // ==================== VALIDATION HELPERS ====================

  /// Check if email is valid
  static bool isValidEmail(String email) {
    return ValidationUtils.emailValidation(email) == null;
  }

  /// Check if phone is valid
  static bool isValidPhone(String phone) {
    return ValidationUtils.phoneValidation(phone) == null;
  }

  // ==================== DATA PARSING ====================

  /// Safely parse any dynamic value to double
  static double toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Safely parse any dynamic value to int
  static int toInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Safely parse any dynamic value to String
  static String toStr(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }
}
