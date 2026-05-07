import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:doctory/core/cache/cache_helper.dart';
import 'package:doctory/core/services/remote_config_service.dart';
import 'package:doctory/core/cache/hive_service.dart';
import 'package:doctory/core/cache/init_hive.dart';
import 'package:doctory/core/network/config/network_config.dart';
import 'package:doctory/core/network/impl/dio_consumer.dart';
import 'package:doctory/core/network/interceptors/auth_interceptor.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/core/network/interfaces/network_info.dart';
import 'package:doctory/core/network/services/pusher_service.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/features/intro/di/intro_di.dart';
import 'package:doctory/features/auth/di/auth_di.dart';
import 'package:doctory/features/home/di/home_di.dart';
import 'package:doctory/features/more/di/more_di.dart';
import 'package:doctory/features/map_home/di/map_home_di.dart';
import 'package:doctory/features/community/di/community_di.dart';

import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Global service locator instance
final GetIt sl = GetIt.instance;

/// Service locator setup class
class ServiceLocator {
  /// Initialize all core services
  static Future<void> init() async {
    // Initialize Hive and Cache first
    await HiveInit.init();
    await CacheHelper.init();
    await UserSession.getUser(); // Ensure token is loaded

    // Register core services
    sl.registerLazySingleton<HiveService>(() => HiveService());



    // Initialize Firebase Analytics
    final analytics = FirebaseAnalytics.instance;
    await analytics.logAppOpen();
    sl.registerLazySingleton<FirebaseAnalytics>(() => analytics);

    // Register network services
    sl.registerLazySingleton<NetworkConfig>(() {
      final config = NetworkConfig.development.copyWith(
        baseUrl: RemoteConfigService.baseUrl,
      );
      debugPrint('NetworkConfig initialized with baseUrl: ${config.baseUrl}');
      return config;
    });

    sl.registerLazySingleton<AuthInterceptor>(() => AuthInterceptor());

    // Register NetworkInfo
    sl.registerLazySingleton<InternetConnection>(() => InternetConnection());
    sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(sl<InternetConnection>()),
    );

    sl.registerLazySingleton<DioConsumer>(
      () => DioConsumer(
        config: sl<NetworkConfig>(),
        authInterceptor: sl<AuthInterceptor>(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );

    sl.registerLazySingleton<ApiConsumer>(() => sl<DioConsumer>());

    // Register shared services
    sl.registerLazySingleton<PusherService>(() => PusherService());

    // Register feature services
    IntroDI.setup();
    AuthDI.setup();
    HomeDI.setup();
    MapHomeDI.setup();
    MoreDI.setup();
    CommunityDI.setup();
  }
}
