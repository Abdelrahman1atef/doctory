import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';

enum AbherButtonVariant { primary, secondary, outline, ghost, danger }

enum AbherButtonSize {
  /// Height 36
  small,

  /// Height 50
  medium,

  /// Height 56
  large,
}

class AbherButton extends StatelessWidget {
  final String? text;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final AbherButtonVariant variant;
  final AbherButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  // Overrides for legacy support / special cases
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Widget? child;

  const AbherButton({
    super.key,
    this.text,
    this.onPressed,
    this.variant = AbherButtonVariant.primary,
    this.size = AbherButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.child,
    this.textStyle,
  });

  bool get _isEnabled => !isDisabled && !isLoading && onPressed != null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: width,
      // height: height ?? _getHeight(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isEnabled ? onPressed : null,
          borderRadius: borderRadius ?? BorderRadius.circular(28),
          child: Container(
            padding: _getPadding(),
            decoration: BoxDecoration(
              color: backgroundColor ?? _getBackgroundColor(),
              border: borderColor != null
                  ? Border.all(color: borderColor!)
                  : _getBorder(),
              borderRadius: borderRadius ?? BorderRadius.circular(28),
              boxShadow: _getBoxShadow(),
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    )
                  : child ??
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (leadingIcon != null) ...[leadingIcon!, 8.ph],
                            if (text != null)
                              Text(text!, style: textStyle ?? _getTextStyle()),
                            if (trailingIcon != null) ...[8.ph, trailingIcon!],
                          ],
                        ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (!_isEnabled) return AppColors.black.withValues(alpha: 0.05);

    switch (variant) {
      case AbherButtonVariant.primary:
        return AppColors.primary;
      case AbherButtonVariant.secondary:
        return AppColors.secondary;
      case AbherButtonVariant.outline:
      case AbherButtonVariant.ghost:
        return Colors.transparent;
      case AbherButtonVariant.danger:
        return AppColors.error;
    }
  }

  Color _getTextColor() {
    if (!_isEnabled) return AppColors.buttonDisabled;

    switch (variant) {
      case AbherButtonVariant.primary:
        return AppColors.white;
      case AbherButtonVariant.secondary:
        return AppColors.white;
      case AbherButtonVariant.outline:
        return AppColors.primary;
      case AbherButtonVariant.ghost:
        return AppColors.black;
      case AbherButtonVariant.danger:
        return AppColors.white;
    }
  }

  BoxBorder? _getBorder() {
    if (variant == AbherButtonVariant.outline && _isEnabled) {
      return Border.all(color: AppColors.primary, width: 1.5);
    }
    return null;
  }

  List<BoxShadow>? _getBoxShadow() {
    if (!_isEnabled) return null;
    if (variant == AbherButtonVariant.primary) {
      return [
        BoxShadow(
          color: AppColors.stitchPrimary.withValues(alpha: 0.25),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];
    }
    return null;
  }

  TextStyle _getTextStyle() {
    final style = AppStyles.s16Medium.copyWith(
      color: textColor ?? _getTextColor(),
      fontWeight: FontWeight.w600,
    );

    switch (size) {
      case AbherButtonSize.small:
        return style.copyWith(fontSize: 12);
      case AbherButtonSize.medium:
        return style;
      case AbherButtonSize.large:
        return style.copyWith(fontSize: 16);
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case AbherButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 15);
      case AbherButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 20);
      case AbherButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 25);
    }
  }
}
