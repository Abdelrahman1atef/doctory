import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

class FormValidator {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.required_field.tr();
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.required_phone.tr();
    }
    if (value.length < 8) {
      return LocaleKeys.phone_dose_not_match.tr();
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.required_email.tr();
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return LocaleKeys.wrong_email_validation.tr();
    }
    return null;
  }

  static String? validateRequired(dynamic value, String errorMessage) {
    if (value == null || (value is String && value.trim().isEmpty)) {
      return errorMessage;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.required_password.tr();
    }
    if (value.length < 6) {
      return LocaleKeys.small_password.tr();
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.confirm_password.tr();
    }
    if (value != password) {
      return LocaleKeys.password_not_match.tr();
    }
    return null;
  }
}
