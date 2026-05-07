import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CreatePostBodySection extends StatelessWidget {
  final TextEditingController contentController;

  const CreatePostBodySection({super.key, required this.contentController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
          Expanded(
            child: TextField(
              controller: contentController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'post_content_hint'.tr(),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
