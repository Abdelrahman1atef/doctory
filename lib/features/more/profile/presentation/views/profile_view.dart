import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/auth/data/repo/auth_repo.dart';
import 'package:doctory/features/create_post/data/data_source/create_post_remote_data_source.dart';
import 'package:doctory/features/more/profile/cubit/profile_cubit.dart';
import 'package:doctory/features/more/profile/presentation/sections/profile_body_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileCubit(sl<AuthRepo>(), sl<CreatePostRemoteDataSource>())
            ..getProfile(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n('personal_profile')),
          centerTitle: true,
        ),
        body: const SafeArea(
          child: ProfileBodySection(),
        ),
      ),
    );
  }
}
