import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/features/community/cubit/post_details_cubit.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:doctory/features/community/presentation/sections/post_details_body_section.dart';
import 'package:doctory/features/community/presentation/widgets/community_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailsView extends StatelessWidget {
  final PostModel post;
  final bool focusComment;

  const PostDetailsView({
    super.key,
    required this.post,
    this.focusComment = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PostDetailsCubit>()..initPost(post),
      child: Scaffold(
        appBar: CommunityAppBar(title: 'post_action'.tr()),
        body: PostDetailsBodySection(focusComment: focusComment),
      ),
    );
  }
}
