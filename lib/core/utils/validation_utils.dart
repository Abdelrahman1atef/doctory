import 'package:easy_localization/easy_localization.dart';

/// نظام التحقق من صحة البيانات والتعبيرات النمطية
/// Comprehensive Data Validation and Regex System
class ValidationUtils {
  ValidationUtils._();

  // ==================== REGULAR EXPRESSIONS ====================

  static final RegExp doubleNumRegEx = RegExp(r'(^\d*\.?\d*)');
  static final RegExp intNumRegEx = RegExp(r'(^\d*)');
  static final RegExp arabicRegEx = RegExp(r'[\u0600-\u06FF]');
  static final RegExp englishReg = RegExp(r"^[a-zA-Z]+$");
  static final RegExp emailReg = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  static final RegExp phoneRegex = RegExp(
    r"^(?:\966)?(5|50|53|56|54|59|51|58|57)([0-9]{8})$",
  );

  // ==================== REGEX HELPERS ====================

  static bool isValidEmail(String email) => emailReg.hasMatch(email);
  static bool isValidSaudiPhone(String phone) => phoneRegex.hasMatch(phone);
  static bool containsArabic(String text) => arabicRegEx.hasMatch(text);
  static bool isEnglishOnly(String text) => englishReg.hasMatch(text);

  // ==================== FIELD VALIDATORS ====================

  /// التحقق من الحقل المطلوب
  static String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.field_required'.tr();
    }
    return null;
  }

  /// التحقق من رقم الهاتف السعودي
  static String? phoneValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.phone_required'.tr();
    }
    if (!isValidSaudiPhone(value.trim())) {
      return 'validation.phone_short'.tr();
    }
    return null;
  }

  /// التحقق من البريد الإلكتروني
  static String? emailValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.email_required'.tr();
    }
    if (!isValidEmail(value.trim())) {
      return 'validation.email_invalid'.tr();
    }
    return null;
  }

  /// التحقق من كلمة المرور
  static String? passwordValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.password_required'.tr();
    }
    if (value.trim().length < 8) {
      return 'validation.password_short'.tr();
    }
    return null;
  }

  /// التحقق من الحد الأدنى للطول
  static String? minLengthValidation(String? value, int minLength) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.field_required'.tr();
    }
    if (value.trim().length < minLength) {
      return 'validation.too_short'.tr(args: [minLength.toString()]);
    }
    return null;
  }
}
