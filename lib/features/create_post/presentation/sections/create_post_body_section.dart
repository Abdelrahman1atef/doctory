import 'package:doctory/core/common/widgets/inputs/custom_text_form_field.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/create_post/presentation/sections/create_post_media_section.dart';
import 'package:doctory/features/create_post/presentation/widgets/media_picker_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CreatePostBodySection extends StatelessWidget {
  final TextEditingController contentController;

  const CreatePostBodySection({super.key, required this.contentController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      const UserInfoRow(),
                      16.ph,
                      CustomTextFormField(
                        controller: contentController,
                        maxLines: 20,
                        hintText: 'post_content_hint'.tr(),
                        fillColor: Colors.transparent,
                        borderColor: Colors.transparent,

                      ),
                    ],
                  ),
                ),

                const CreatePostMediaSection(),
              ],
            ),
          ),
        ),
        const MediaPickerBar(),
      ],
    );
  }
}

class UserInfoRow extends StatelessWidget {
  const UserInfoRow({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: UserSession.userNotifier,
      builder: (context, user, child) {
        final String userName = (user is Map)
            ? (user['fullName'] ?? user['name'] ?? 'User').toString()
            : 'User';
        final String? imageUrl = (user is Map)
            ? (user['profilePictureUrl'] ?? user['avatar'])?.toString()
            : null;

        return Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.grey100,
              backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                  ? NetworkImage(imageUrl.toImageUrl)
                  : null,
              child: (imageUrl == null || imageUrl.isEmpty)
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            12.pw,
            Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }
}
