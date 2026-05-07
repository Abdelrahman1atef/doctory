import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/community/cubit/community_cubit.dart';
import 'package:doctory/features/community/presentation/sections/posts_list_section.dart';
import 'package:doctory/features/community/presentation/sections/community_floating_action_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommunityView extends StatelessWidget {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CommunityCubit>()..getPosts(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: const PostsListSection(),
        floatingActionButton: const CommunityFloatingActionSection(),
      ),
    );
  }
}
