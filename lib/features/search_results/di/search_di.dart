import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/search_results/cubit/search_cubit.dart';
import 'package:doctory/features/search_results/data/data_source/search_remote_data_source.dart';
import 'package:doctory/features/search_results/data/repo/search_repo.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

class SearchDI {
  static void setup() {
    // Data Sources
    if (!sl.isRegistered<SearchRemoteDataSource>()) {
      sl.registerLazySingleton<SearchRemoteDataSource>(
        () => SearchRemoteDataSourceImpl(sl<ApiConsumer>()),
      );
    }

    // Repositories
    if (!sl.isRegistered<SearchRepo>()) {
      sl.registerLazySingleton<SearchRepo>(() => SearchRepoImpl(sl()));
    }

    // Cubits
    if (!sl.isRegistered<SearchCubit>()) {
      sl.registerFactory(() => SearchCubit(sl()));
    }
  }
}
