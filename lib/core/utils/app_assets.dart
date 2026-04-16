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
      icons.home,
      icons.privetOrder,
      icons.order,
      icons.chat,
      icons.more,
      icons.notification,
      // icons.search, // search.svg missing in assets folder
      icons.location,
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

  String get splash => '$_base/splash.png';
  String get splashWhite => '$_base/splash_white.png';
  String get logo => '$_base/logo.png';
  String get logoSvg => '$_base/logo.svg';
  String get logoWhite => '$_base/logoWhite.png';

  String get onboarding1 => '$_base/onboarding1.svg';
  String get onboarding2 => '$_base/onboarding2.svg';

  String get placeholder => '$_base/placeholder.png';
  String get error => '$_base/error.png';
  String get success => '$_base/success.png';
  String get loading => '$_base/loading.png';

  String get banner1 => '$_base/banner1.png';
  String get boat1 => '$_base/boat1.png';
  String get jeyBoat1 => '$_base/jet_boat1.png';
  String get yacht1 => '$_base/yacht1.png';

  String get loginVictor => '$_base/login_victor.svg';

  String get applePay => '$_base/apple_pay.png';
  String get mastercard => '$_base/mastercard.png';
  String get mada => '$_base/mada.png';
  String get visa => '$_base/visa.png';

  String get userImage1 => '$_base/user_image1.png';
  String get qr => '$_base/qr.png';
  String get shareIllustration => '$_base/share_illustration.png';
}

class _Icons {
  const _Icons();

  final String _base = 'assets/icons';

  String get home => '$_base/home.svg';
  String get profile => '$_base/profile.svg';
  String get settings => '$_base/settings.svg';
  String get search => '$_base/search.svg';
  String get notification => '$_base/notification.svg';

  String get back => '$_base/back.svg';
  String get forward => '$_base/forward.svg';
  String get close => '$_base/close.svg';
  String get menu => '$_base/menu.svg';

  String get success => '$_base/success.svg';
  String get error => '$_base/error.svg';
  String get warning => '$_base/warning.svg';
  String get info => '$_base/info.svg';

  String get location => '$_base/location.svg';
  String get refresh => '$_base/refresh.svg';
  String get favorite => '$_base/favorite.svg';
  String get witherInfo => '$_base/wither_info.svg';
  String get addLocation => '$_base/add_location.svg';
  String get mapFullScreen => '$_base/map_full_screen.svg';

  String get diving => '$_base/diving.svg';
  String get fishing => '$_base/fishing.svg';
  String get safari => '$_base/safari.svg';
  String get seaTrips => '$_base/sea_trips.svg';

  String get filter => '$_base/filter.svg';
  String get anchorsLogo => '$_base/anchors_logo.svg';
  String get money => '$_base/money.svg';
  String get mail => '$_base/mail.svg';

  String get rateIcon => '$_base/rate_icon.svg';
  String get arrowLeft => '$_base/arrow_left.svg';
  String get arrowRight => '$_base/arrow_right.svg';
  String get breakfast => '$_base/breakfast.svg';
  String get calender => '$_base/calender.svg';
  String get clock => '$_base/clock.svg';
  String get juice => '$_base/juice.svg';
  String get routing => '$_base/routing.svg';
  String get waterGames => '$_base/water_games.svg';

  String get person => '$_base/person.svg';
  String get love => '$_base/love.svg';
  String get star => '$_base/star.svg';
  String get user => '$_base/user.svg';

  String get timer => '$_base/timer.svg';

  String get wrong => '$_base/wrong.svg';
  String get selected => '$_base/selected.svg';
  String get selectPeople => '$_base/select_people.svg';
  String get male => '$_base/male.svg';
  String get female => '$_base/female.svg';
  String get discount => '$_base/discount.svg';
  String get canceledOrder => '$_base/canceled_order.svg';
  String get quickOrder => '$_base/quick_order.svg';
  String get arrowDown => '$_base/arrow_down.svg';

  String get paymentSucceeded => '$_base/payment_succeeded.svg';
  String get wallet => '$_base/wallet.svg';
  String get handMoney => '$_base/hand_money.svg';

  String get special => '$_base/special.svg';

  String get phone => '$_base/phone.svg';
  String get personName => '$_base/person_name.svg';
  String get id => '$_base/id.svg';

  String get anchorsName => '$_base/anchors_name.svg';

  String get emptyChat => '$_base/empty_chat.svg';
  String get mic => '$_base/mic.svg';
  String get pickImage => '$_base/pick_image.svg';
  String get pickMap => '$_base/pick_map.svg';
  String get send => '$_base/send.svg';
  String get playRec => '$_base/play_rec.svg';

  String get heartBroken => '$_base/heart_broken.svg';
  String get filledFavorite => '$_base/filled_favorite.svg';

  String get delete => '$_base/delete.svg';
  String get notificationBroken => '$_base/notification_broken.svg';

  String get waves => '$_base/waves.svg';
  String get share => '$_base/share.svg';
  String get privacy => '$_base/privacy.svg';
  String get police => '$_base/police.svg';
  String get logout => '$_base/logout.svg';
  String get lang => '$_base/lang.svg';
  String get editProfile => '$_base/edit_profile.svg';
  String get callUs => '$_base/call_us.svg';
  String get commonQuestions => '$_base/common_q.svg';
  String get outstandingDebts => '$_base/outstanding_debts.svg';
  String get msgEdit => '$_base/msg_edit.svg';
  String get msgSend => '$_base/msg_send.svg';
  String get whatsapp => '$_base/whatsapp.svg';
  String get instagram => '$_base/instagram.svg';
  String get snapchat => '$_base/snapchat.svg';
  String get x => '$_base/x.svg';

  String get emptyOrders => '$_base/empty_orders.svg';

  String get privetOrder => '$_base/privet_order.svg';
  String get order => '$_base/order.svg';
  String get chat => '$_base/chat.svg';
  String get more => '$_base/more.svg';
}
