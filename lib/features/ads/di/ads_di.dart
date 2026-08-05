import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/ads/data/data_source/ads_remote_data_source.dart';
import 'package:doctory/features/ads/data/repo/ads_repo.dart';

class AdsDI {
  static void setup() {
    sl.registerLazySingleton<AdsRemoteDataSource>(
      () => AdsRemoteDataSourceImpl(sl<ApiConsumer>()),
    );
    sl.registerLazySingleton<AdsRepo>(
      () => AdsRepoImpl(sl<AdsRemoteDataSource>()),
    );
  }
}