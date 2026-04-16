import 'package:doctory/core/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AbherBackButton extends StatelessWidget {
  const AbherBackButton({
    super.key,
    this.onBack,
    this.color,
    this.icon,
    this.size,
  });
  final VoidCallback? onBack;
  final Color? color;
  final IconData? icon;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (onBack != null) {
          onBack?.call();
        } else {
          context.pop();
        }
      },
      icon: AppAssets.svg(AppAssets.icons.back, width: 24),
    );
  }
}
