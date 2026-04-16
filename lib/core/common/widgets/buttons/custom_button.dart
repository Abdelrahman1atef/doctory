import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;

  const CustomButton({
    super.key,
    this.text,
    required this.onPressed,
    this.backgroundColor,
    this.height,
    this.width,
    this.textStyle,
    this.textColor,
    this.borderRadius,
    this.leadingIcon,
    this.trailingIcon,
    this.padding,
    this.child,
    this.borderColor,
    this.isLoading = false,
  });

  CustomButton.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
    this.width,
    this.textStyle,
    this.borderRadius,
    this.leadingIcon,
    this.trailingIcon,
    this.padding,
    this.child,
    Color? backgroundColor,
    Color? borderColor,
    Color? textColor,
    this.isLoading = false,
  }) : backgroundColor = backgroundColor ?? Colors.transparent,
       borderColor = borderColor ?? AppColors.secondary,
       textColor = textColor ?? AppColors.secondary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primary,
          borderRadius: borderRadius ?? BorderRadius.circular(10),
          border: Border.all(color: borderColor ?? Colors.transparent),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
            : child ??
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (leadingIcon != null) ...[leadingIcon!, 8.ph],
                      Text(
                        text ?? '',
                        style:
                            textStyle ??
                            AppStyles.s14Medium.copyWith(
                              color: textColor ?? AppColors.white,
                            ),
                      ),
                      if (trailingIcon != null) ...[8.ph, trailingIcon!],
                    ],
                  ),
      ),
    );
  }
}
