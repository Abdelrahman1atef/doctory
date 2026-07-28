import 'package:doctory/core/config/deep_link_config.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/core/router/app_router.dart';
import 'package:doctory/core/services/deep_link_service.dart';
import 'package:go_router/go_router.dart';
import 'package:doctory/features/community/cubit/community_cubit.dart';
import 'package:doctory/features/community/cubit/post_details_cubit.dart';
import 'package:doctory/features/community/data/data_source/community_remote_data_source.dart';
import 'package:doctory/features/community/data/repo/community_repo.dart';

class CommunityDI {
  static void setup() {
    // Data Sources
    sl.registerLazySingleton<CommunityRemoteDataSource>(
      () => CommunityRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
    );

    // Repositories
    sl.registerLazySingleton<CommunityRepo>(
      () =>
          CommunityRepoImpl(remoteDataSource: sl<CommunityRemoteDataSource>()),
    );

    // Cubits
    sl.registerFactory<CommunityCubit>(
      () => CommunityCubit(sl<CommunityRepo>()),
    );
    sl.registerFactory<PostDetailsCubit>(
      () => PostDetailsCubit(sl<CommunityRepo>()),
    );

    // Deep link handler — /post/{postId}
    DeepLinkService.instance.register((uri) {
      if (uri.scheme != DeepLinkConfig.scheme ||
          uri.host != DeepLinkConfig.host) {
        return false;
      }
      if (!uri.path.startsWith('/post/')) return false;
      final postId = uri.pathSegments.last;
      if (postId.isEmpty) return false;
      DeepLinkService.instance.setPendingPath('/post/$postId');
      AppRouter.navigatorKey.currentContext?.go('/post/$postId');
      return true;
    });
  }
}
