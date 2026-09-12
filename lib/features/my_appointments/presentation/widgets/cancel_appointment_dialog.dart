import 'package:doctory/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';

Future<String?> showCancelAppointmentDialog(BuildContext context) {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) =>
        AlertDialog(
          title: Text('cancel_appointment'.tr(),style: AppStyles.s16SemiBold.withColor(AppColors.black),),
          content: TextField(
            controller: controller,
            maxLines: 3,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'cancel_reason_hint'.tr(),
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('no'.tr(),style: AppStyles.s14Medium.withColor(AppColors.primary)),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (ctx, value, _) =>
                  TextButton(
                    onPressed: value.text
                        .trim()
                        .isEmpty
                        ? null
                        : () => Navigator.of(ctx).pop(value.text.trim()),
                    child: Text(
                      'yes'.tr(),
                      style: AppStyles.s14Medium.withColor(AppColors.error),
                    ),
                  ),
            ),
          ],
        ),
  );
}