import 'package:doctory/core/common/widgets/images/abher_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' as fs;

/// نظام الأصول المطور - Modern Assets Management
/// تنظيم هرمي وسهل للوصول لجميع موارد التطبيق
class AppAssets {
  AppAssets._();

  // ==================== IMAGE ASSETS ====================
  static const images = _Images();

  // ==================== ICON ASSETS ====================
  static const icons = _Icons();

  // ==================== HELPER METHODS ====================

  /// عرض صورة عادية (تدعم الأصول والشبكة)
  static Widget image(
    String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    double? radius,
  }) => AbherImage(
    path,
    width: width,
    height: height,
    fit: fit,
    color: color,
    radius: radius,
  );

  /// عرض أيقونة SVG
  static Widget svg(
    String path, {
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) => fs.SvgPicture.asset(
    path,
    width: width,
    height: height,
    fit: fit,
    colorFilter: color != null
        ? ColorFilter.mode(color, BlendMode.srcIn)
        : null,
  );

  /// تحضير الأيقونات الأساسية في الذاكرة لمنع التأخير (Pre-caching)
  static Future<void> precacheIcons() async {
    final List<String> iconsToCache = [

    ];

    for (final iconPath in iconsToCache) {
      try {
        final loader = fs.SvgAssetLoader(iconPath);
        await fs.svg.cache.putIfAbsent(
          loader.cacheKey(null),
          () => loader.loadBytes(null),
        );
        // debugPrint('✅ [AppAssets] precached: $iconPath');
      } catch (e) {
        debugPrint('⚠️ [AppAssets] failed to precache icon: $iconPath - $e');
      }
    }
  }
}

class _Images {
  const _Images();

  final String _base = 'assets/images';


}

class _Icons {
  const _Icons();

  final String _base = 'assets/icons';


}
