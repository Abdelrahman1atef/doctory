import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';

class ProductActionButton extends StatelessWidget {
  const ProductActionButton({
    super.key,
    required this.onTap,
    required this.title,
    this.isLoading = false,
    this.isAdded = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.disabled = false,
  });

  final VoidCallback onTap;
  final String title;
  final bool isLoading;
  final bool isAdded;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    // Determine colors based on state
    Color getBackgroundColor() {
      if (backgroundColor != null) return backgroundColor!;
      if (disabled) return AppColors.grey400;
      if (isAdded) return AppColors.success;
      return AppColors.black;
    }

    Color getTextColor() {
      if (textColor != null) return textColor!;
      if (disabled) return AppColors.grey600;
      return AppColors.white;
    }

    Color getIconColor() {
      if (isAdded) return AppColors.success;
      if (disabled) return AppColors.grey600;
      return AppColors.white;
    }

    return InkWell(
      onTap: (isLoading || isAdded || disabled) ? null : onTap,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
            bottomRight: Radius.circular(35),
            bottomLeft: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: getBackgroundColor().withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Row(
            children: [
              16.ph,
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: isAdded ? AppColors.white : AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                    bottomRight: Radius.circular(25),
                    bottomLeft: Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              getIconColor(),
                            ),
                          ),
                        )
                      : icon != null
                      ? Icon(icon, size: 24, color: getIconColor())
                      : Icon(
                          isAdded
                              ? Icons.check_circle_rounded
                              : Icons.shopping_cart_rounded,
                          size: 24,
                          color: getIconColor(),
                        ),
                ),
              ),
              const Spacer(flex: 3),
              Text(
                title,
                style: AppStyles.s14Medium.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: getTextColor(),
                ),
              ),
              const Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }
}
