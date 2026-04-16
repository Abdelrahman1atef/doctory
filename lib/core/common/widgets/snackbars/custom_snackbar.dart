import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';

class AbherSnackbar {
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle_rounded,
      iconColor: Colors.green.shade600,
      duration: duration,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.red.shade600,
      icon: Icons.error_rounded,
      iconColor: Colors.red.shade600,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.primary,
      icon: Icons.info_rounded,
      iconColor: AppColors.primary,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.orange.shade600,
      icon: Icons.warning_rounded,
      iconColor: Colors.orange.shade600,
      duration: duration,
    );
  }

  static void showAddToCartSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onCartTap,
  }) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.shopping_cart_checkout_rounded,
      iconColor: Colors.green.shade600,
      duration: duration,
      actionLabel: 'common.view_cart'.tr(),
      onAction: onCartTap,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required Color iconColor,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.only(top: 32, left: 16, right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 18),
      borderRadius: BorderRadius.circular(18),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.10),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
      icon: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      messageText: Text(
        message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.s16Medium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          height: 1,
          fontSize: 14,
        ),
      ),
      duration: duration,
      animationDuration: const Duration(milliseconds: 400),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      isDismissible: true,
      mainButton: (actionLabel != null && onAction != null)
          ? TextButton(
              onPressed: () {
                onAction();
              },
              child: Text(
                actionLabel,
                style: AppStyles.s14Medium.copyWith(color: Colors.white),
              ),
            )
          : null,
    ).show(context);
  }
}
