import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_spacing.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// App header used inside a screen's body — never in `Scaffold(appBar:)`.
///
/// The app is edge-to-edge, so the header owns the status-bar inset itself
/// instead of relying on a `SafeArea` ancestor.
class CustomAppBar extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final bool canNavigateUp;
  final Color? backgroundColor;

  /// Replaces the default back button when the screen needs its own.
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions = const <Widget>[],
    this.canNavigateUp = true,
    this.backgroundColor,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top;
    return Container(
      color: backgroundColor ?? AppColors.white,
      padding: EdgeInsetsDirectional.only(
        top: topInset,
        start: AppSpacing.s4,
        end: AppSpacing.s4,
      ),
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          children: [
            SizedBox(
              width: kToolbarHeight,
              child: leading ?? (canNavigateUp ? const _BackButton() : null),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.s20SemiBold.withColor(AppColors.textPrimary),
              ),
            ),
            // Balances the leading slot so the title stays optically centred.
            if (actions.isEmpty)
              const SizedBox(width: kToolbarHeight)
            else
              Row(mainAxisSize: MainAxisSize.min, children: actions),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: context.pop,
      icon: const Icon(
        Icons.arrow_back_outlined,
        color: AppColors.textPrimary,
      ),
    );
  }
}
