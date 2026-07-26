import 'package:doctory/core/services/remote_config_service.dart';

abstract class DeepLinkConfig {
  static const String scheme = 'https';

  static String get host {
    final url = RemoteConfigService.frontendUrl;
    if (url.isEmpty) return 'clinicHub.app';
    try {
      return Uri.parse(url).host;
    } catch (_) {
      return 'clinicHub.app';
    }
  }
}
