import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  static Future<void> shareApp() async {
    const String androidAppId = 'com.masader.Abhr';
    // TODO(dev): Add iOS App ID when available
    const String playStoreUrl =
        'https://play.google.com/store/apps/details?id=$androidAppId';

    // Using the existing share body as the message content
    final String message =
        '${LocaleKeys.profile_share_body.tr()}\n\n$playStoreUrl';

    await Share.share(message);
  }
}
