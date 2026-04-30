import 'package:flutter/material.dart';
import '../../../../core/common/widgets/inputs/stitch_text_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';

class ForgotPasswordFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final VoidCallback onSubmit;

  const ForgotPasswordFormWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// Header
        Text(
          context.l10n('forgot_password_title'),
          style: AppStyles.s24Bold.copyWith(color: AppColors.textPrimary),
        ),
        8.ph,
        Text(
          context.l10n('forgot_password_subtitle'),
          style: AppStyles.s14Medium.copyWith(color: AppColors.textSecondary),
        ),

        40.ph,

        /// Form
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StitchTextField(
                controller: emailController,
                label: context.l10n('email'),
                hintText: 'name@example.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.stitchPrimary,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n('required_email');
                  }
                  if (!RegExp(
                    r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return context.l10n('wrong_email_validation');
                  }
                  return null;
                },
              ),

              40.ph,

              /// Submit Button
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
                    context.l10n('send_reset_link'),
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
