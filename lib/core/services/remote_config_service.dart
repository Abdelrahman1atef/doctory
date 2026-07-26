import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class RemoteConfigService {
  static final FirebaseRemoteConfig _remoteConfig =
      FirebaseRemoteConfig.instance;
  static String _localAppVersion = "";

  static Future<void> init() async {
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      _localAppVersion = '${info.version}+${info.buildNumber}';

      await _remoteConfig.setDefaults({
        "BASE_URL": "https://doctory-icare.runasp.net/api/v1/",
        "android_version": "1.0.0+1",
        "ios_version": "1.0.0+1",
        "android_store_link": "",
        "ios_store_link": "",
        "force_update": false,
        "SHOW_FACEBOOK_AUTH": false,
        "SHOW_GOOGLE_AUTH": false,
        "SHOW_MAP_DIRECTIONS_FAB": false,
        "FRONTEND_URL": "https://doctory.runasp.net/",
      });

      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 5),
          minimumFetchInterval: kDebugMode
              ? const Duration(seconds: 1)
              : const Duration(hours: 1),
        ),
      );

      // Add a fallback timeout so it doesn't block the app indefinitely
      await _remoteConfig.fetchAndActivate().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint("⚠️ Remote Config fetch timed out, using defaults.");
          return false;
        },
      );
      debugPrint("✅ Remote Config Fetched Successfully!");
    } catch (e) {
      debugPrint("❌ Remote Config Error: $e");
    }
  }

  static String get baseUrl => _remoteConfig.getString("BASE_URL");
  static String get androidVersion =>
      _remoteConfig.getString("android_version");
  static String get iosVersion => _remoteConfig.getString("ios_version");
  static bool get isForceUpdate => _remoteConfig.getBool("force_update");
  static String get androidStoreLink =>
      _remoteConfig.getString("android_store_link");
  static String get iosStoreLink => _remoteConfig.getString("ios_store_link");

  // Social Auth Toggles
  static bool get showFacebookAuth =>
      _remoteConfig.getBool("SHOW_FACEBOOK_AUTH");
  static bool get showGoogleAuth => _remoteConfig.getBool("SHOW_GOOGLE_AUTH");
  static bool get showMapDirectionsFab =>
      _remoteConfig.getBool("SHOW_MAP_DIRECTIONS_FAB");

  static String get frontendUrl =>
      _remoteConfig.getString("FRONTEND_URL");

  // For Force Update
  static bool get needsForceUpdate {
    if (!isForceUpdate) return false;

    final String remoteVersion = Platform.isIOS ? iosVersion : androidVersion;

    return _isLower(_localAppVersion, remoteVersion);
  }

  static bool _isLower(String local, String remote) {
    try {
      List<String> localParts = local.split('+')[0].split('.');
      List<String> remoteParts = remote.split('+')[0].split('.');
      int minLength = localParts.length < remoteParts.length
          ? localParts.length
          : remoteParts.length;

      for (int i = 0; i < minLength; i++) {
        int l = int.parse(localParts[i]);
        int r = int.parse(remoteParts[i]);

        if (l < r) return true;
        if (l > r) return false;
      }

      int localBuild = int.parse(
        local.contains('+') ? local.split('+')[1] : '0',
      );
      int remoteBuild = int.parse(
        remote.contains('+') ? remote.split('+')[1] : '0',
      );

      return localBuild < remoteBuild;
    } catch (e) {
      debugPrint("Error parsing version in _isLower: $e");
      return local != remote;
    }
  }
}
