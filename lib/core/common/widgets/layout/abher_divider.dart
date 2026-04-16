import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';

class AbherDivider extends StatelessWidget {
  final double? height;
  final Color? color;

  const AbherDivider({super.key, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color ?? AppColors.textHint.withValues(alpha: .2),
      child: SizedBox(width: context.width, height: height ?? .5),
    );
  }
}
