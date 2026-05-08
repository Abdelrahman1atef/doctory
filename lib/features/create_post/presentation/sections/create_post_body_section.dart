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
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.grey100,
                            child: const Icon(Icons.person, color: Colors.grey),
                          ),
                          12.pw,
                          Text(
                            'user'.tr(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      16.ph,
                      TextField(
                        controller: contentController,
                        maxLines: null,
                        minLines: 3,
                        decoration: InputDecoration(
                          hintText: 'post_content_hint'.tr(),
                          border: InputBorder.none,
                        ),
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
