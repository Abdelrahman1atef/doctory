import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Full-width CTA in the Stitch design language (filled or outlined).
class StitchButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;

  const StitchButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
  });

  static const double _height = 56;
  static const double _radius = 12;

  @override
  Widget build(BuildContext context) {
    final foreground = isOutlined ? AppColors.stitchPrimaryContainer : Colors.white;
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius));
    final child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
          )
        : Text(text, style: AppStyles.s16SemiBold.copyWith(color: foreground));
    final callback = isLoading ? null : onPressed;

    return SizedBox(
      height: _height,
      width: double.infinity,
      child: isOutlined
          ? OutlinedButton(
              onPressed: callback,
              style: OutlinedButton.styleFrom(
                foregroundColor: foreground,
                side: const BorderSide(color: AppColors.stitchPrimaryContainer),
                shape: shape,
              ),
              child: child,
            )
          : ElevatedButton(
              onPressed: callback,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.stitchPrimaryContainer,
                disabledBackgroundColor: AppColors.stitchPrimaryContainer.withValues(alpha: 0.6),
                foregroundColor: foreground,
                elevation: 0,
                shape: shape,
              ),
              child: child,
            ),
    );
  }
}
