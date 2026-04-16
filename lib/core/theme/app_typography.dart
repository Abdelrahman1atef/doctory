import 'package:flutter/material.dart';

/// نظام الخطوط - Typography System
/// تم تنظيم الملف باستخدام أصناف مجردة (abstract classes) لتقسيم المسؤوليات
abstract class AppStyles {
  static const String fontFamily = 'Bukra';

  // ==================== COMPATIBILITY ALIASES ====================
  // يمكن استدعاء هذه الأنماط مباشرة من AppStyles للحفاظ على سهولة الكود الحالي
  static TextStyle get s10Medium => AppTextSizes.s10.medium;
  static TextStyle get s10Bold => AppTextSizes.s10.bold;

  static TextStyle get s12Medium => AppTextSizes.s12.medium;
  static TextStyle get s12Bold => AppTextSizes.s12.bold;
  static TextStyle get s13Medium => AppTextSizes.s13.medium;
  static TextStyle get s13Bold => AppTextSizes.s13.bold;
  static TextStyle get s14Light => AppTextSizes.s14.light;
  static TextStyle get s14Medium => AppTextSizes.s14.medium;
  static TextStyle get s14SemiBold => AppTextSizes.s14.semiBold;
  static TextStyle get s14Bold => AppTextSizes.s14.bold;
  static TextStyle get s16Medium => AppTextSizes.s16.medium;
  static TextStyle get s16SemiBold => AppTextSizes.s16.semiBold;
  static TextStyle get s16Bold => AppTextSizes.s16.bold;
  static TextStyle get s18Medium => AppTextSizes.s18.medium;
  static TextStyle get s18Bold => AppTextSizes.s18.bold;
  static TextStyle get s20SemiBold => AppTextSizes.s20.semiBold;
  static TextStyle get s20Bold => AppTextSizes.s20.bold;
  static TextStyle get s24Bold => AppTextSizes.s24.bold;
  static TextStyle get s26Bold => AppTextSizes.s26.bold;
}

/// الأصناف الأساسية للأحجام - Base Text Sizes
abstract class AppTextSizes {
  static TextStyle _base(double size) => TextStyle(
    fontFamily: AppStyles.fontFamily,
    fontSize: size,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  static TextStyle get s10 => _base(10);
  static TextStyle get s12 => _base(12);
  static TextStyle get s13 => _base(13);
  static TextStyle get s14 => _base(14);
  static TextStyle get s16 => _base(16);
  static TextStyle get s18 => _base(18);
  static TextStyle get s20 => _base(20);
  static TextStyle get s24 => _base(24);
  static TextStyle get s26 => _base(26);
  static TextStyle get s28 => _base(28);
  static TextStyle get s32 => _base(32);
}

/// أنماط النصوص المعيارية - Semantic Styles
abstract class AppSemanticStyles {
  static TextStyle get h1 => AppTextSizes.s32.bold;
  static TextStyle get h2 => AppTextSizes.s24.bold;
  static TextStyle get h3 => AppTextSizes.s20.semiBold;

  static TextStyle get title => AppTextSizes.s18.medium;
  static TextStyle get body => AppTextSizes.s16.regular;
  static TextStyle get caption => AppTextSizes.s12.regular;
  static TextStyle get button => AppTextSizes.s16.semiBold;
}

/// ملحقات لتسهيل التحكم بالأوزان والألوان - Style Extensions
extension TextStyleX on TextStyle {
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get extraBold => copyWith(fontWeight: FontWeight.w800);

  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withSize(double size) => copyWith(fontSize: size);
  TextStyle underline() => copyWith(decoration: TextDecoration.underline);
}
