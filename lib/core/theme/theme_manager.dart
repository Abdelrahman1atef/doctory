import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// مدير الثيمات البسيط
class AppThemeManager {
  AppThemeManager._();

  static final AppThemeManager _instance = AppThemeManager._();
  static AppThemeManager get instance => _instance;

  /// ValueNotifier للثيم الحالي
  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  /// الثيم الفاتح
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    scaffoldBackgroundColor: AppColors.lightColorScheme.surface,
    tabBarTheme: TabBarThemeData(
      labelPadding: const EdgeInsetsDirectional.symmetric(vertical: 10),
      overlayColor: WidgetStatePropertyAll(
        AppColors.secondary.withValues(alpha: 0.04),
      ),
      indicator: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      dividerHeight: 0,
      unselectedLabelStyle: AppStyles.s16Medium.withColor(
        AppColors.anchorsText,
      ),
      labelStyle: AppStyles.s16Medium.withColor(AppColors.white),
      splashBorderRadius: BorderRadius.circular(15),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.radio;
      }),
      overlayColor: WidgetStateProperty.all(
        AppColors.secondary.withValues(alpha: 0.04),
      ),
      splashRadius: 20,
    ),
  );

  /// الثيم الداكن
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColors.darkColorScheme,
    scaffoldBackgroundColor: AppColors.darkColorScheme.surface,
  );

  /// تهيئة مدير الثيمات
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedTheme = prefs.getString('theme_mode');

    if (savedTheme != null) {
      themeNotifier.value = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
  }

  /// تعيين الثيم الفاتح
  void setLightTheme() {
    themeNotifier.value = ThemeMode.light;
    _saveThemePreference(ThemeMode.light);
  }

  /// تعيين الثيم الداكن
  void setDarkTheme() {
    themeNotifier.value = ThemeMode.dark;
    _saveThemePreference(ThemeMode.dark);
  }

  /// تعيين ثيم النظام
  void setSystemTheme() {
    themeNotifier.value = ThemeMode.system;
    _saveThemePreference(ThemeMode.system);
  }

  /// تبديل الثيم
  void toggleTheme() {
    if (themeNotifier.value == ThemeMode.light) {
      setDarkTheme();
    } else {
      setLightTheme();
    }
  }

  /// حفظ تفضيل الثيم
  Future<void> _saveThemePreference(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.toString());
  }

  /// تنظيف الموارد
  void dispose() {
    themeNotifier.dispose();
  }
}
