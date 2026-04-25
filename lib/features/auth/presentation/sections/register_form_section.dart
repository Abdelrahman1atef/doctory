import 'package:doctory/core/common/widgets/inputs/stitch_text_field.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/services/social_auth_service.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/core/common/widgets/buttons/social_auth_button.dart';
import 'package:doctory/features/auth/cubit/auth_cubit.dart';
import 'package:doctory/features/auth/cubit/auth_states.dart';
import 'package:doctory/features/auth/data/model/signup_request.dart';
import 'package:doctory/core/services/alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class RegisterFormSection extends StatefulWidget {
  const RegisterFormSection({super.key});

  @override
  State<RegisterFormSection> createState() => _RegisterFormSectionState();
}

class _RegisterFormSectionState extends State<RegisterFormSection> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _birthDateController = TextEditingController();

  late String _selectedGender;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _selectedGender = 'male';
  }

  /// Strips leading '0' from the phone number for backend submission.
  String _getFormattedPhone() {
    final phone = _phoneController.text.trim();
    if (phone.startsWith('0')) {
      return phone.substring(1);
    }
    return phone;
  }

  int _getGenderValue() {
    switch (_selectedGender) {
      case 'male':
        return 1;
      case 'female':
        return 2;
      default:
        return 3;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _handleSocialAuth(
    Future<SocialAuthResult?> Function() signInMethod,
  ) async {
    final result = await signInMethod();
    if (result != null && mounted) {
      context.read<AuthCubit>().socialLogin(
        provider: result.provider,
        accessToken: result.accessToken,
        name: result.name,
        email: result.email,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          SmartDialog.showLoading();
        } else {
          SmartDialog.dismiss();
        }

        if (state is SignupSuccessState) {
          context.push(AppRoutes.otpVerification, extra: state.email);
        } else if (state is AuthSuccessState) {
          context.go(AppRoutes.completeProfile);
        } else if (state is AuthErrorState) {
          Alerts.showSnackBar(context, message: state.message, state: SnackState.failed);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Full Name
            StitchTextField(
              controller: _nameController,
              label: context.tr('full_name'),
              hintText: 'John Doe',
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: AppColors.stitchPrimary,
              ),
              validator: (value) => value == null || value.isEmpty
                  ? context.tr('field_required')
                  : null,
            ),

            20.ph,

            /// Email
            StitchTextField(
              controller: _emailController,
              label: context.tr('email'),
              hintText: 'example@mail.com',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AppColors.stitchPrimary,
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return context.tr('field_required');
                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value))
                  return context.tr('invalid_email');
                return null;
              },
            ),

            20.ph,

            /// Phone Number (Egyptian Format)
            StitchTextField(
              controller: _phoneController,
              label: context.tr('phone_number'),
              hintText: '01XXXXXXXXX',
              keyboardType: TextInputType.phone,
              maxLength: 11,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    Container(
                      width: 1,
                      height: 20,
                      color: AppColors.cardBorder,
                    ),
                  ],
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return context.tr('field_required');
                if (value.length != 11) return context.tr('invalid_phone');
                return null;
              },
            ),

            20.ph,

            /// Birth Date
            StitchTextField(
              controller: _birthDateController,
              label: context.tr('birth_date'),
              hintText: 'YYYY-MM-DD',
              readOnly: true,
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(
                    const Duration(days: 365 * 20),
                  ),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  _birthDateController.text = picked.toIso8601String().split(
                    'T',
                  )[0];
                }
              },
              prefixIcon: const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.stitchPrimary,
              ),
              validator: (value) => value == null || value.isEmpty
                  ? context.tr('field_required')
                  : null,
            ),

            20.ph,

            /// Gender Selection
            Text(
              context.tr('gender'),
              style: AppStyles.s14Medium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            8.ph,
            Row(
              children: [
                Expanded(
                  child: _GenderChip(
                    label: context.tr('male'),
                    isSelected: _selectedGender == 'male',
                    onTap: () => setState(() => _selectedGender = 'male'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GenderChip(
                    label: context.tr('female'),
                    isSelected: _selectedGender == 'female',
                    onTap: () => setState(() => _selectedGender = 'female'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GenderChip(
                    label: context.tr('other'),
                    isSelected: _selectedGender == 'other',
                    onTap: () => setState(() => _selectedGender = 'other'),
                  ),
                ),
              ],
            ),

            20.ph,

            /// Password
            StitchTextField(
              controller: _passwordController,
              label: context.tr('password'),
              hintText: '••••••••',
              obscureText: _obscurePassword,
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.stitchPrimary,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (value) => value == null || value.length < 6
                  ? context.tr('password_too_short')
                  : null,
            ),

            20.ph,

            /// Confirm Password
            StitchTextField(
              controller: _confirmPasswordController,
              label: context.tr('confirm_password'),
              hintText: '••••••••',
              obscureText: _obscureConfirmPassword,
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.stitchPrimary,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
              ),
              validator: (value) {
                if (value != _passwordController.text)
                  return context.tr('passwords_dont_match');
                return null;
              },
            ),

            32.ph,

            /// Register Button
            SizedBox(
              height: 56,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthCubit>().signup(
                      SignupRequest(
                        fullName: _nameController.text.trim(),
                        email: _emailController.text.trim(),
                        password: _passwordController.text,
                        confirmPassword: _confirmPasswordController.text,
                        phoneNumber: _getFormattedPhone(),
                        birthDate: _birthDateController.text,
                        gender: _getGenderValue(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.stitchPrimaryContainer,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  context.tr('create_account'),
                  style: AppStyles.s16SemiBold,
                ),
              ),
            ),

            24.ph,

            /// Social Registration
            Row(
              children: [
                const Expanded(
                  child: Divider(color: AppColors.cardBorder, thickness: 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    context.tr('or_register_with'),
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

            24.ph,

            SocialAuthButton(
              title: context.tr('continue_with_google'),
              icon: const Icon(
                Icons.g_mobiledata_rounded,
                color: Colors.red,
                size: 36,
              ),
              onTap: () =>
                  _handleSocialAuth(sl<SocialAuthService>().signInWithGoogle),
            ),

            16.ph,

            SocialAuthButton(
              title: context.tr('continue_with_facebook'),
              icon: const Icon(
                Icons.facebook_rounded,
                color: Colors.blue,
                size: 28,
              ),
              onTap: () =>
                  _handleSocialAuth(sl<SocialAuthService>().signInWithFacebook),
            ),

            24.ph,

            /// Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.tr('already_have_account'),
                  style: AppStyles.s14Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    context.tr('login'),
                    style: AppStyles.s14SemiBold.copyWith(
                      color: AppColors.stitchPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.stitchPrimary.withAlpha(25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.stitchPrimary : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: AppStyles.s14Medium.copyWith(
            color: isSelected
                ? AppColors.stitchPrimary
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
