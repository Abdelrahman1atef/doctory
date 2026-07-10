import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/services/file_upload_service.dart';
import 'package:doctory/core/services/post_upload_service.dart';
import 'package:doctory/features/create_post/cubit/create_post_cubit.dart';
import 'package:doctory/features/create_post/data/data_source/create_post_remote_data_source.dart';
import 'package:doctory/features/create_post/data/repo/create_post_repo.dart';

void setupCreatePostDI() {
  sl.registerLazySingleton<CreatePostRemoteDataSource>(
    () => CreatePostRemoteDataSourceImpl(
      apiConsumer: sl(),
      fileUploadService: sl<FileUploadService>(),
    ),
  );
  sl.registerLazySingleton<CreatePostRepo>(
    () => CreatePostRepoImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<PostUploadService>(
    () => PostUploadService(repo: sl()),
  );
  sl.registerFactory(() => CreatePostCubit());
}
