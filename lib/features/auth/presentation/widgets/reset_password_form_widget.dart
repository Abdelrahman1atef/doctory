import 'package:flutter/material.dart';
import '../../../../core/common/widgets/inputs/stitch_text_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';

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
          'reset_password_title'.tr(),
          style: AppStyles.s24Bold.copyWith(color: AppColors.textPrimary),
        ),
        8.ph,
        Text(
          'reset_password_subtitle'.tr(),
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
                label: 'new_password'.tr(),
                hintText: 'enter_new_password'.tr(),
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
                  if (value == null || value.isEmpty) {
                    return 'password_required'.tr();
                  }
                  if (value.length < 6) {
                    return 'password_too_short'.tr();
                  }
                  return null;
                },
              ),
              24.ph,
              StitchTextField(
                controller: confirmPasswordController,
                label: 'confirm_password'.tr(),
                hintText: 're_enter_password'.tr(),
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
                  if (value == null || value.isEmpty) {
                    return 'confirm_password_required'.tr();
                  }
                  if (value != passwordController.text) {
                    return 'passwords_dont_match'.tr();
                  }
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
                    'reset_password'.tr(),
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
