import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:doctory/core/common/widgets/snackbars/custom_toast_widget.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_typography.dart';

import 'package:doctory/core/theme/app_colors.dart';
import '../app_strings/locale_keys.dart';
import '../utils/extensions.dart';

enum SnackState { success, failed, info }

class Alerts {
  static Future<T?> dialog<T>(
    BuildContext context, {
    required Widget child,
    RouteSettings? routeSettings,
    EdgeInsets? insetPadding,
    AlignmentGeometry? alignment,
    Color? backgroundColor,
  }) {
    return showDialog<T>(
      context: context,
      routeSettings: routeSettings,
      builder: (context) => Dialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: backgroundColor,
        insetPadding: insetPadding ?? const EdgeInsets.all(50),
        alignment: alignment,
        child: child,
      ),
    );
  }

  static Future<T?> infoDialog<T>(
    BuildContext context, {
    required Widget child,
    RouteSettings? routeSettings,
    EdgeInsets? insetPadding,
    AlignmentGeometry? alignment,
    Color? backgroundColor,
    Widget? footer,
    String? info,
  }) {
    return showDialog<T>(
      context: context,
      routeSettings: routeSettings,
      builder: (context) => Dialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: backgroundColor,
        insetPadding: insetPadding ?? const EdgeInsets.all(50),
        alignment: alignment,
        child: child,
      ),
    );
  }

  static Future<T?> bottomSheet<T>(
    BuildContext context, {
    required Widget child,
    RouteSettings? routeSettings,
    EdgeInsets? insetPadding,
    double? height,
    AlignmentGeometry? alignment,
    Color? backgroundColor,

    Color? barrierColor,
    bool isShape = true,
  }) {
    return showModalBottomSheet<T>(
      useRootNavigator: true,
      barrierColor: barrierColor,
      enableDrag: true,
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      elevation: 0,

      backgroundColor:
          backgroundColor ?? const Color.fromARGB(255, 255, 255, 255),
      context: context,
      builder: (context) => SafeArea(
        minimum: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isShape)
              Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            child,
          ],
        ),
      ),
    );
  }

  static Future<bool?> confirmDialog(
    BuildContext context, {
    required String text,
  }) async {
    return await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: ((context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(LocaleKeys.no.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(LocaleKeys.yes.tr()),
          ),
        ],
      )),
    );
  }

  static void snack({required String text, required SnackState state}) {
    BotToast.showCustomText(
      align: Alignment.center,
      onlyOne: true,
      toastBuilder: (s) => AbherToastWidget(state: state, text: text),
    );
  }

  static void showSnackBar(
    BuildContext context, {
    required String message,
    SnackState state = SnackState.success,
  }) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                state == SnackState.success
                    ? Icons.check_circle_outline
                    : (state == SnackState.failed
                          ? Icons.error_outline
                          : Icons.info_outline),
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state == SnackState.success
                          ? context.tr('success')
                          : (state == SnackState.failed
                                ? context.tr('error')
                                : context.tr('info')),
                      style: AppStyles.s16Bold.copyWith(color: Colors.white),
                    ),
                    5.ph,
                    Text(
                      message,
                      style: AppStyles.s14Bold.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: state == SnackState.success
              ? AppColors.stitchPrimary
              : (state == SnackState.failed
                    ? AppColors.errorColor
                    : AppColors.stitchPrimaryContainer),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 4),
          elevation: 6,
        ),
      );
  }

  /// Show a toast message using SmartDialog
  static void showToast(
    String message, {
    Duration displayTime = const Duration(seconds: 2),
    Color? backgroundColor,
  }) {
    SmartDialog.showToast(
      message,
      displayTime: displayTime,
      alignment: Alignment.bottomCenter,
      maskColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.stitchPrimaryContainer,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          message,
          style: AppStyles.s14Bold.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
