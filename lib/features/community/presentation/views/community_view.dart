import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/community/cubit/community_cubit.dart';
import 'package:doctory/features/community/presentation/sections/posts_list_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CommunityView extends StatelessWidget {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CommunityCubit>()..getPosts(),
      child: Scaffold(
        backgroundColor: AppColors.grey100,
        body: const PostsListSection(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push(AppRoutes.createPost).then((value) {
              // Note: Ideally, we should refresh the list if a post was created.
              // In this structure, since CommunityCubit is scoped here, we might need 
              // a way to trigger refresh. A global event bus or popping with true.
            });
          },
          backgroundColor: AppColors.stitchPrimary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
