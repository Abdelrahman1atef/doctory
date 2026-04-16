import 'dart:io';

import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctory/core/services/media/my_media.dart';

import '../alerts.dart';
import 'item_of_contact.dart';

class AlertOfMedia extends StatelessWidget {
  const AlertOfMedia({
    super.key,
    required this.onCameraSelected,
    required this.onGallerySelected,
  });

  final ValueChanged<File?>? onCameraSelected;
  final ValueChanged<File?>? onGallerySelected;

  Future<void> _handleMediaSelection(
    BuildContext context,
    Future<File?> Function() pickMedia,
    ValueChanged<File?>? onMediaSelected,
  ) async {
    try {
      final File? selectedMedia = await pickMedia();
      context.pop(); // Close the dialog
      if (selectedMedia != null) {
        onMediaSelected?.call(selectedMedia);
      } else {
        Alerts.snack(
          state: SnackState.failed,
          text: 'common.no_images_selected'.tr(),
        );
      }
    } catch (e) {
      context.pop();
      Alerts.snack(state: SnackState.failed, text: 'common.error'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _handleMediaSelection(
              context,
              MediaService().pickImageFromCamera,
              onCameraSelected,
            ),
            child: ItemOfContact(
              title: 'camera'.tr(),
              choose: true,
              isImage: true,
            ),
          ),
          16.ph,
          GestureDetector(
            onTap: () => _handleMediaSelection(
              context,
              MediaService().pickImageFromGallery,
              onGallerySelected,
            ),
            child: ItemOfContact(
              title: 'gallery'.tr(),
              choose: false,
              isImage: true,
            ),
          ),
        ],
      ),
    );
  }
}
