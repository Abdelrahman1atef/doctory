import 'package:doctory/core/config/deep_link_config.dart';
import 'package:doctory/core/services/alerts.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/features/chat/data/repo/chat_repo.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

class PostOptionsBottomSheet extends StatelessWidget {
  final PostModel post;

  const PostOptionsBottomSheet({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final isMe = post.authorId == UserSession.userId;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isMe)
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: Text('start_conversation'.tr()),
              onTap: () async {
                SmartDialog.showLoading();
                final result =
                    await sl<ChatRepo>().createConversation(post.authorId);
                SmartDialog.dismiss();

                result.fold(
                  onSuccess: (conversationId) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      context.push('/chat/room/$conversationId');
                    }
                  },
                  onFailure: (failure) {
                    Alerts.showToast(failure.message);
                  },
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.copy),
            title: Text('copy_link'.tr()),
            onTap: () {
              final subPath = '/post/${post.id}';
              final url = '${DeepLinkConfig.scheme}://${DeepLinkConfig.host}$subPath';
              Clipboard.setData(ClipboardData(text: url));
              Navigator.pop(context);
              Alerts.showToast('copy_link'.tr());
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.report_outlined),
          //   title: Text('report'.tr()),
          //   onTap: () => Navigator.pop(context),
          // ),
          if (isMe)
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
