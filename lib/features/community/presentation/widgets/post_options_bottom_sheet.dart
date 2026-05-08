import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PostOptionsBottomSheet extends StatelessWidget {
  final PostModel post;

  const PostOptionsBottomSheet({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.copy),
            title: Text('copy_link'.tr()),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.report_outlined),
            title: Text('report'.tr()),
            onTap: () => Navigator.pop(context),
          ),
          if (post.authorId == 'me')
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(
                'delete'.tr(),
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () => Navigator.pop(context),
            ),
        ],
      ),
    );
  }
}
