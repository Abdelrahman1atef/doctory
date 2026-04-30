import 'package:flutter/material.dart';
import '../../../../core/common/widgets/inputs/stitch_text_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';

class ResetPasswordFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onSubmit;

  const ResetPasswordFormWidget({
    super.key,
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n('reset_password_title'),
          style: AppStyles.s24Bold.copyWith(color: AppColors.textPrimary),
        ),
        8.ph,
        Text(
          context.l10n('reset_password_subtitle'),
          style: AppStyles.s14Medium.copyWith(color: AppColors.textSecondary),
        ),
        40.ph,
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StitchTextField(
                controller: passwordController,
                label: context.l10n('new_password'),
                hintText: context.l10n('enter_new_password'),
                obscureText: obscurePassword,
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.stitchPrimary,
                ),
                suffixIcon: IconButton(
                  onPressed: onTogglePassword,
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return context.l10n('password_required');
                  if (value.length < 6)
                    return context.l10n('password_too_short');
                  return null;
                },
              ),
              24.ph,
              StitchTextField(
                controller: confirmPasswordController,
                label: context.l10n('confirm_password'),
                hintText: context.l10n('re_enter_password'),
                obscureText: obscureConfirmPassword,
                prefixIcon: const Icon(
                  Icons.lock_reset_rounded,
                  color: AppColors.stitchPrimary,
                ),
                suffixIcon: IconButton(
                  onPressed: onToggleConfirmPassword,
                  icon: Icon(
                    obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return context.l10n('confirm_password_required');
                  if (value != passwordController.text)
                    return context.l10n('passwords_dont_match');
                  return null;
                },
              ),
              40.ph,
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.stitchPrimaryContainer,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    context.l10n('reset_password'),
                    style: AppStyles.s16SemiBold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
