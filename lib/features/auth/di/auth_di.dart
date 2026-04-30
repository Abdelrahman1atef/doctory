import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/core/services/social_auth_service.dart';
import 'package:doctory/features/auth/cubit/auth_cubit.dart';
import 'package:doctory/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:doctory/features/auth/data/repo/auth_repo.dart';

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
        () => AuthCubit(sl<AuthRepo>(), sl<SocialAuthService>()));
  }
}
