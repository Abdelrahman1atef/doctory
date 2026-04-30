import 'package:flutter/material.dart';
import '../../../../core/common/widgets/buttons/social_auth_button.dart';
import '../../../../core/common/widgets/inputs/stitch_text_field.dart';
import '../../../../core/services/remote_config_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';

class LoginFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onForgotPassword;
  final VoidCallback onLogin;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onFacebookSignIn;
  final VoidCallback onRegister;

  const LoginFormWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onForgotPassword,
    required this.onLogin,
    required this.onGoogleSignIn,
    required this.onFacebookSignIn,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Email Field
          Text(
            context.l10n('email_address'),
            style: AppStyles.s14Medium.copyWith(
              color: AppColors.stitchSecondary,
            ),
          ),
          8.ph,
          StitchTextField(
            controller: emailController,
            hintText: context.l10n('enter_your_email'),
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined, size: 20),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n('email_required');
              }
              if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return context.l10n('invalid_email');
              }
              return null;
            },
          ),

          24.ph,

          /// Password Field
          Text(
            context.l10n('password'),
            style: AppStyles.s14Medium.copyWith(
              color: AppColors.stitchSecondary,
            ),
          ),
          8.ph,
          StitchTextField(
            controller: passwordController,
            hintText: context.l10n('enter_your_password'),
            obscureText: obscurePassword,
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
            suffixIcon: IconButton(
              onPressed: onTogglePassword,
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: AppColors.stitchSecondary,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n('password_required');
              }
              if (value.length < 6) {
                return context.l10n('password_too_short');
              }
              return null;
            },
          ),

          const SizedBox(height: 12),

          /// Forgot Password Link
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: onForgotPassword,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                context.l10n('forgot_password'),
                style: AppStyles.s14Medium.copyWith(
                  color: AppColors.stitchPrimary,
                ),
              ),
            ),
          ),

          32.ph,

          /// Login Button
          SizedBox(
            height: 56,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.stitchPrimaryContainer,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(context.l10n('login'), style: AppStyles.s16SemiBold),
            ),
          ),

          24.ph,

          /// Divider
          if (RemoteConfigService.showGoogleAuth ||
              RemoteConfigService.showFacebookAuth)
            Row(
              children: [
                const Expanded(
                  child: Divider(color: AppColors.cardBorder, thickness: 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    context.l10n('or_login_with'),
                    style: AppStyles.s14Medium.copyWith(
                      color: AppColors.stitchSecondary,
                    ),
                  ),
                ),
                const Expanded(
                  child: Divider(color: AppColors.cardBorder, thickness: 1),
                ),
              ],
            ),

          /// Social Auth Buttons
          if (RemoteConfigService.showGoogleAuth) ...[
            32.ph,
            SocialAuthButton(
              title: context.l10n('continue_with_google'),
              icon: const Icon(
                Icons.g_mobiledata_rounded,
                color: Colors.red,
                size: 36,
              ),
              onTap: onGoogleSignIn,
            ),
          ],

          if (RemoteConfigService.showFacebookAuth) ...[
            if (!RemoteConfigService.showGoogleAuth) 32.ph else 16.ph,
            SocialAuthButton(
              title: context.l10n('continue_with_facebook'),
              icon: const Icon(
                Icons.facebook_rounded,
                color: Colors.blue,
                size: 28,
              ),
              onTap: onFacebookSignIn,
            ),
          ],

          24.ph,

          /// Register Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.l10n('dont_have_account'),
                style: AppStyles.s14Medium.copyWith(
                  color: AppColors.stitchSecondary,
                ),
              ),
              TextButton(
                onPressed: onRegister,
                child: Text(
                  context.l10n('register_now'),
                  style: AppStyles.s14SemiBold.copyWith(
                    color: AppColors.stitchPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
