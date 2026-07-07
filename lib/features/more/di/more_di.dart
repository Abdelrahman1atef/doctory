import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/services/social_auth_service.dart';
import 'package:doctory/features/auth/data/repo/auth_repo.dart';
import 'package:doctory/features/create_post/data/data_source/create_post_remote_data_source.dart';
import 'package:doctory/features/more/cubit/more_cubit.dart';
import 'package:doctory/features/more/profile/cubit/profile_cubit.dart';

class MoreDI {
  static void setup() {
    sl.registerFactory<MoreCubit>(
      () => MoreCubit(sl<AuthRepo>(), sl<SocialAuthService>()),
    );
    sl.registerFactory<ProfileCubit>(
      () => ProfileCubit(sl<AuthRepo>(), sl<CreatePostRemoteDataSource>()),
    );
  }
}
