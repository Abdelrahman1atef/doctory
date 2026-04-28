import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService(this._remoteConfig);

  static Future<RemoteConfigService> init() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 5), // simplified interval
      ));

      // Default values
      await remoteConfig.setDefaults({
        'BASE_URL': 'https://doctory-icare.runasp.net/api/v1/',
      });

      debugPrint('Fetching Firebase Remote Config...');
      await remoteConfig.fetch();
      bool activated = await remoteConfig.activate();
      debugPrint('✅✅✅ Firebase Remote Config activated successfully.${remoteConfig.getString('BASE_URL')}');
      if (activated) {
        
        debugPrint('✅✅✅ Firebase Remote Config activated successfully.');
      } else {
        debugPrint('⛔❌ Firebase Remote Config: No new updates or already activated.');
      }

      debugPrint('✅✅✅ Remote Config BASE_URL: ${remoteConfig.getString('BASE_URL')}');
    } on FirebaseException catch (e) {
      debugPrint('⛔❌ Firebase Remote Config Error: [${e.code}] ${e.message}');
    } catch (e) {
      debugPrint('⛔❌ Firebase Remote Config initialization failed: $e');
    }

    return RemoteConfigService(remoteConfig);
  }

  String get baseUrl => _remoteConfig.getString('BASE_URL');
}
