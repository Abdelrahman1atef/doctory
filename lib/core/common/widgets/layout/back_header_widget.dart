import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Transparent header holding nothing but a back button.
///
/// The app is edge-to-edge, so this widget owns the status-bar inset rather
/// than relying on a `SafeArea` ancestor. Drop it at the top of a body Column
/// in place of a `Scaffold(appBar:)` slot.
class BackHeaderWidget extends StatelessWidget {
  final Color iconColor;

  const BackHeaderWidget({super.key, this.iconColor = AppColors.stitchPrimary});

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsetsDirectional.only(top: topInset),
      child: SizedBox(
        height: kToolbarHeight,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: BackButton(color: iconColor, onPressed: context.pop),
        ),
      ),
    );
  }
}
