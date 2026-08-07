import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/features/map_home/cubit/map_home_cubit.dart';
import 'package:doctory/features/map_home/data/data_source/map_home_remote_data_source.dart';
import 'package:doctory/features/map_home/data/repo/map_home_repo.dart';

class MapHomeDI {
  static void setup() {
    sl.registerLazySingleton<MapHomeRemoteDataSource>(
      () => MapHomeRemoteDataSourceImpl(sl()),
    );
    sl.registerLazySingleton<MapHomeRepo>(() => MapHomeRepoImpl(sl()));
    sl.registerFactory(() => MapHomeCubit(sl(), sl()));
  }
}
