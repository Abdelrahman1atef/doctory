import 'package:flutter/material.dart';
import 'package:doctory/core/utils/app_assets.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    this.image,
    required this.title,
    this.color,
    this.subtitle,
    this.width,
  });
  final String title;
  final String? image, subtitle;
  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image != null)
            AppAssets.svg(
              image!.contains('.svg') ? image! : image!.svg(),
              width: width ?? 150,
              color: color,
            ),
          if (image != null) 12.ph,
          Text(
            title,
            style: AppStyles.s16Bold.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
          12.ph,
          if (subtitle != null && subtitle!.isNotEmpty)
            Text(
              subtitle!,
              style: AppStyles.s12Medium.copyWith(
                fontSize: 12,
                color: "B0B0B0".toColor(),
              ),
            ),
        ],
      ),
    );
  }
}
