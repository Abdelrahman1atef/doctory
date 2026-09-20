import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/common/widgets/buttons/stitch_button.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AvailabilityActionsWidget extends StatelessWidget {
  final VoidCallback onAdd;

  /// When null the "finish setup" button is hidden.
  final VoidCallback? onFinish;

  const AvailabilityActionsWidget({
    super.key,
    required this.onAdd,
    this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StitchButton(
            text: LocaleKeys.add_availability.tr(),
            onPressed: onAdd,
          ),
          if (onFinish != null) ...[
            16.ph,
            StitchButton(
              text: LocaleKeys.finish_setup.tr(),
              isOutlined: true,
              onPressed: onFinish,
            ),
          ],
        ],
      ),
    );
  }
}
