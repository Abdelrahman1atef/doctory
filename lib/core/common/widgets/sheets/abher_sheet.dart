import 'package:doctory/core/common/widgets/buttons/abher_button.dart';
import 'package:doctory/core/common/widgets/images/abher_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';

class AbherSheet extends StatelessWidget {
  final String title;
  final String? description;
  final String? icon;
  final Widget? iconWidget;
  final Widget? widget;

  // Primary Action
  final String? primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final AbherButtonVariant primaryButtonVariant;

  // Secondary Action
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final AbherButtonVariant secondaryButtonVariant;

  const AbherSheet({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.iconWidget,
    this.primaryButtonText,
    this.onPrimaryPressed,
    this.primaryButtonVariant = AbherButtonVariant.primary,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.secondaryButtonVariant = AbherButtonVariant.ghost,
    this.widget,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconWidget != null)
                SizedBox(height: 62, width: 62, child: iconWidget)
              else if (icon != null)
                AbherImage(icon!, width: 62, height: 62),

              if (icon != null || iconWidget != null) 16.ph,

              Text(
                title,
                style: AppStyles.s16Bold.withColor(AppColors.secondary),
                textAlign: TextAlign.center,
              ),

              if (description != null) ...[
                8.ph,
                Text(
                  description!,
                  style: AppStyles.s14Medium.copyWith(
                    color: AppColors.textHint,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (widget != null) ...[25.ph, widget!],
              if (primaryButtonText != null) ...[
                22.ph,
                AbherButton(
                  text: primaryButtonText!,
                  variant: primaryButtonVariant,
                  onPressed: onPrimaryPressed,
                ),
              ],

              if (secondaryButtonText != null) ...[
                10.ph,
                AbherButton(
                  text: secondaryButtonText!,
                  variant: secondaryButtonVariant,
                  backgroundColor:
                      secondaryButtonVariant == AbherButtonVariant.ghost
                      ? AppColors.black.withValues(alpha: .05)
                      : null,
                  textColor: secondaryButtonVariant == AbherButtonVariant.ghost
                      ? AppColors.textHint
                      : null,
                  onPressed: onSecondaryPressed ?? () => context.pop(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
