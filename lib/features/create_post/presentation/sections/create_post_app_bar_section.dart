import 'package:doctory/core/common/widgets/buttons/custom_button.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/community/presentation/widgets/community_app_bar.dart';
import 'package:doctory/features/create_post/cubit/create_post_cubit.dart';
import 'package:doctory/features/create_post/cubit/create_post_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreatePostAppBarSection extends StatelessWidget
    implements PreferredSizeWidget {
  final TextEditingController contentController;

  const CreatePostAppBarSection({super.key, required this.contentController});

  @override
  Widget build(BuildContext context) {
    return CommunityAppBar(
      title: 'create_post'.tr(),
      actions: [
        BlocBuilder<CreatePostCubit, CreatePostStates>(
          builder: (context, state) {
            return CustomButton(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20,vertical: 10),
              onPressed: () {
                final text = contentController.text.trim();
                final cubit = context.read<CreatePostCubit>();

                // Only submit if there's content or media
                if (text.isNotEmpty || cubit.selectedMedia.isNotEmpty) {
                  cubit.submitPost(text);
                  context.pop(true); // Pop immediately like Facebook
                }
              },
              child: Text(
                'post_action'.tr(),
                style: AppStyles.s14SemiBold.withColor(AppColors.white),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
