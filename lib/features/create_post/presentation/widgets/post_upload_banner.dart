import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/services/post_upload_service.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PostUploadBanner extends StatelessWidget {
  const PostUploadBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final uploadService = sl<PostUploadService>();

    return StreamBuilder<List<PostUploadTask>>(
      stream: uploadService.tasksStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: snapshot.data!.map((task) {
            return _buildTaskBanner(context, task, uploadService);
          }).toList(),
        );
      },
    );
  }

  Widget _buildTaskBanner(
    BuildContext context,
    PostUploadTask task,
    PostUploadService service,
  ) {
    Color bgColor;
    Widget leading;
    String statusText;
    List<Widget> actions = [];

    switch (task.status) {
      case UploadStatus.uploading:
        bgColor = AppColors.stitchPrimary.withValues(alpha: 0.1);
        leading = const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
        statusText = 'publishing_post'.tr();
        break;
      case UploadStatus.success:
        bgColor = Colors.green.withValues(alpha: 0.1);
        leading = const Icon(Icons.check_circle, color: Colors.green);
        statusText = 'post_published'.tr();
        break;
      case UploadStatus.failed:
        bgColor = Colors.red.withValues(alpha: 0.1);
        leading = const Icon(Icons.error, color: Colors.red);
        statusText = 'post_failed'.tr();
        actions = [
          TextButton(
            onPressed: () => service.retryTask(task.id),
            child: Text(
              'retry'.tr(),
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // "Save as draft" option requested by user.
              // For now we dismiss the task, but the user can retry before dismissing.
              service.dismissTask(task.id);
            },
            child: Text(
              'dismiss'.tr(),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ];
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: AppColors.grey100)),
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              statusText,
              style: TextStyle(
                color: task.status == UploadStatus.failed
                    ? Colors.red
                    : AppColors.stitchPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}
