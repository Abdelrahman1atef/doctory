import 'dart:async';
import 'dart:developer';

import 'package:doctory/core/config/deep_link_config.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/core/router/app_router.dart';
import 'package:doctory/core/services/deep_link_service.dart';
import 'package:doctory/core/services/file_upload_service.dart';
import 'package:doctory/core/services/social_auth_service.dart';
import 'package:doctory/features/auth/cubit/auth_cubit.dart';
import 'package:doctory/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:doctory/features/auth/data/repo/auth_repo.dart';
import 'package:go_router/go_router.dart';

class AuthDI {
  static void setup() {
    // Data sources
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl<ApiConsumer>()),
    );

    // Repositories
    sl.registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(sl<AuthRemoteDataSource>()),
    );

    // Services
    sl.registerLazySingleton<SocialAuthService>(() => SocialAuthService());

    // Cubits
    sl.registerFactory<AuthCubit>(
      () => AuthCubit(sl<AuthRepo>(), sl<SocialAuthService>(), sl<FileUploadService>()),
    );

    // Deep link handlers
    DeepLinkService.instance.register((uri) {
      if (uri.scheme != DeepLinkConfig.scheme ||
          uri.host != DeepLinkConfig.host) {
        return false;
      }

      // /auth/* — navigate to login
      if (uri.path.startsWith('/auth/')) {
        AppRouter.navigatorKey.currentContext?.go('/login');
        return true;
      }

      // /clinic/setup?clinicId=&userId=&token= — verify HMAC then navigate
      if (uri.path.startsWith('/clinic/setup')) {
        _handleClinicSetupDeepLink(uri);
        return true;
      }

      return false;
    });
  }

  static void _handleClinicSetupDeepLink(Uri uri) {
    final clinicId = uri.queryParameters['clinicId'] ?? '';
    final userId = uri.queryParameters['userId'] ?? '';
    final token = uri.queryParameters['token'] ?? '';

    if (clinicId.isEmpty || userId.isEmpty || token.isEmpty) {
      AppRouter.navigatorKey.currentContext?.go('/login');
      return;
    }

    unawaited(_verifyAndNavigate(clinicId, userId, token));
  }

  static Future<void> _verifyAndNavigate(
    String clinicId,
    String userId,
    String token,
  ) async {
    final repo = sl<AuthRepo>();
    final data = 'clinic-approval:$clinicId:$userId';
    final result = await repo.verifyDeepLink(data, token);

    if (AppRouter.navigatorKey.currentContext == null) return;

    result.fold(
      onSuccess: (valid) {
        if (valid) {
          AppRouter.navigatorKey.currentContext!.go(
            '/clinic-complete-profile',
            extra: {'clinicId': clinicId, 'userId': userId},
          );
        } else {
          log('Deep link verification failed: invalid token');
          AppRouter.navigatorKey.currentContext!.go('/login');
        }
      },
      onFailure: (failure) {
        log('Deep link verification error: ${failure.message}');
        AppRouter.navigatorKey.currentContext!.go('/login');
      },
    );
  }
}
