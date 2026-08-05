import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/ads/data/repo/ads_repo.dart';
import 'package:doctory/features/home/cubit/home_cubit.dart';
import 'package:doctory/features/home/data/data_source/home_remote_data_source.dart';
import 'package:doctory/features/home/data/repo/home_repo.dart';

class HomeDI {
  static void setup() {
    sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(sl<ApiConsumer>()),
    );
    sl.registerLazySingleton<HomeRepo>(
      () => HomeRepoImpl(sl<HomeRemoteDataSource>()),
    );
    sl.registerFactory<HomeCubit>(() => HomeCubit(sl<HomeRepo>(), sl<AdsRepo>()));
  }
}
