import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/common/widgets/buttons/social_auth_button.dart';
import '../../../../core/common/widgets/inputs/stitch_text_field.dart';
import '../../../../core/services/remote_config_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';
import 'package:doctory/features/auth/presentation/widgets/gender_selection_widget.dart';

class RegisterFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String? selectedGender;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final Function(String) onGenderChanged;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onSubmit;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onFacebookSignIn;
  final VoidCallback onLogin;

  const RegisterFormWidget({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.dayController,
    required this.monthController,
    required this.yearController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.selectedGender,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onGenderChanged,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onSubmit,
    required this.onGoogleSignIn,
    required this.onFacebookSignIn,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Full Name
          StitchTextField(
            controller: nameController,
            label: context.l10n('full_name'),
            hintText: 'John Doe',
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.stitchPrimary,
            ),
            validator: (value) => value == null || value.isEmpty
                ? context.l10n('field_required')
                : null,
          ),

          20.ph,

          /// Email
          StitchTextField(
            controller: emailController,
            label: context.l10n('email'),
            hintText: 'example@mail.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.stitchPrimary,
            ),
            validator: (value) {
              if (value == null || value.isEmpty)
                return context.l10n('field_required');
              if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value))
                return context.l10n('invalid_email');
              return null;
            },
          ),

          20.ph,

          /// Phone Number (Egyptian Format)
          StitchTextField(
            controller: phoneController,
            label: context.l10n('phone_number'),
            hintText: '01XXXXXXXXX',
            keyboardType: TextInputType.phone,
            maxLength: 11,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textDirection: TextDirection.ltr,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🇪🇬', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 4),
                  Text(
                    '+20',
                    style: AppStyles.s14Medium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(width: 1, height: 20, color: AppColors.cardBorder),
                ],
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty)
                return context.l10n('field_required');
              if (value.length != 11) return context.l10n('invalid_phone');
              return null;
            },
          ),

          20.ph,

          /// Birth Date Split (Day, Month, Year)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: context.l10n('birth_date'),
                  style: AppStyles.s14Bold.copyWith(color: AppColors.onSurface),
                ),
                TextSpan(
                  text: ' ${context.l10n('optional')}',
                  style: AppStyles.s14Bold.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          8.ph,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: StitchTextField(
                  controller: dayController,
                  hintText: context.l10n('day'),
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  isRequired: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    final day = int.tryParse(value);
                    if (day == null || day < 1 || day > 31) return '';
                    return null;
                  },
                ),
              ),
              12.pw,
              Expanded(
                flex: 2,
                child: StitchTextField(
                  controller: monthController,
                  hintText: context.l10n('month'),
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  isRequired: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    final month = int.tryParse(value);
                    if (month == null || month < 1 || month > 12) return '';
                    return null;
                  },
                ),
              ),
              12.pw,
              Expanded(
                flex: 3,
                child: StitchTextField(
                  controller: yearController,
                  hintText: context.l10n('year'),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  isRequired: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    final year = int.tryParse(value);
                    if (year == null || year < 1900 || year > DateTime.now().year)
                      return '';
                    return null;
                  },
                ),
              ),
            ],
          ),

          20.ph,

          /// Gender Selection
          GenderSelectionWidget(
            selectedGender: selectedGender,
            onGenderChanged: onGenderChanged,
          ),

          20.ph,

          /// Password
          StitchTextField(
            controller: passwordController,
            label: context.l10n('password'),
            hintText: '••••••••',
            obscureText: obscurePassword,
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.stitchPrimary,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: onTogglePassword,
            ),
            validator: (value) => value == null || value.length < 6
                ? context.l10n('password_too_short')
                : null,
          ),

          20.ph,

          /// Confirm Password
          StitchTextField(
            controller: confirmPasswordController,
            label: context.l10n('confirm_password'),
            hintText: '••••••••',
            obscureText: obscureConfirmPassword,
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.stitchPrimary,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: onToggleConfirmPassword,
            ),
            validator: (value) {
              if (value != passwordController.text)
                return context.l10n('passwords_dont_match');
              return null;
            },
          ),

          32.ph,

          /// Register Button
          SizedBox(
            height: 56,
            width: double.infinity,
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
                context.l10n('create_account'),
                style: AppStyles.s16SemiBold,
              ),
            ),
          ),

          24.ph,

          /// Social Registration
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
                    context.l10n('or_register_with'),
                    style: AppStyles.s14Medium.copyWith(
                      color: AppColors.textSecondary,
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
            24.ph,
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
            if (!RemoteConfigService.showGoogleAuth) 24.ph else 16.ph,
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

          /// Login Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.l10n('already_have_account'),
                style: AppStyles.s14Medium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              TextButton(
                onPressed: onLogin,
                child: Text(
                  context.l10n('login'),
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
