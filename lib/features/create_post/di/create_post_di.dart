import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/features/create_post/cubit/create_post_cubit.dart';
import 'package:doctory/features/create_post/data/data_source/create_post_remote_data_source.dart';
import 'package:doctory/features/create_post/data/repo/create_post_repo.dart';

void setupCreatePostDI() {
  sl.registerLazySingleton<CreatePostRemoteDataSource>(
    () => CreatePostRemoteDataSourceImpl(apiConsumer: sl()),
  );
  sl.registerLazySingleton<CreatePostRepo>(
    () => CreatePostRepoImpl(remoteDataSource: sl()),
  );
  sl.registerFactory(() => CreatePostCubit(sl()));
}
