import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

class LauncherHelper {
  static void openUrl(
    String url, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) {
    final urlParse = Uri.parse(url);
    launchUrl(urlParse);
  }

  // call
  static void call(
    String phone, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) {
    final phoneUrl = Uri.parse("tel:$phone");
    launchUrl(phoneUrl);
  }
  // WhatsApp whatsapp = WhatsApp();

  //wa
  static Future<void> openWhatsApp(
    String phone, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    log(phone);
    var whatsappUrl = Uri.parse(
      "https://api.whatsapp.com/send?phone=+966$phone",
    );
    log(whatsappUrl.toString());
    await canLaunchUrl(whatsappUrl)
        ? launchUrl(whatsappUrl, mode: LaunchMode.externalApplication)
        : log(
            "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed",
          );
  }

  static void openGoogleMaps(double latitude, double longitude) async {
    Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
