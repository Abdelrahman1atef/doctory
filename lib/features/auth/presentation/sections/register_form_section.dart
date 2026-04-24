import 'package:doctory/core/common/widgets/inputs/stitch_text_field.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/core/common/widgets/buttons/social_auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

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
    _selectedGender = 'male'; // Use key instead of literal
  }

  /// Strips leading '0' from the phone number for backend submission.
  /// Example: '01022322745' -> '1022322745'
  String _getFormattedPhone() {
    final phone = _phoneController.text.trim();
    if (phone.startsWith('0')) {
      return phone.substring(1);
    }
    return phone;
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Name Input
          StitchTextField(
            controller: _nameController,
            label: context.tr('enter_your_name'),
            hintText: context.tr('full_name_hint'),
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.stitchPrimary,
            ),
            validator: (value) => value == null || value.isEmpty
                ? context.tr('required_field')
                : null,
          ),

          20.ph,

          /// Email Input
          StitchTextField(
            controller: _emailController,
            label: context.tr('email'),
            hintText: 'name@example.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.stitchPrimary,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.tr('required_email');
              }
              if (!value.contains('@')) {
                return context.tr('wrong_email_validation');
              }
              return null;
            },
          ),

          20.ph,

          /// Phone Number
          StitchTextField(
            controller: _phoneController,
            label: context.tr('phone_number'),
            hintText: '1XX XXX XXXX',
            keyboardType: TextInputType.phone,
            maxLength: 11,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            prefix: Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🇪🇬', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 6),
                  Text(
                    '+20',
                    style: AppStyles.s14Bold.copyWith(
                      color: AppColors.stitchPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(width: 1, height: 24, color: AppColors.cardBorder),
                ],
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.tr('required_phone');
              }
              if (value.length != 11) {
                return context.tr('invalid_phone');
              }
              return null;
            },
          ),

          20.ph,

          /// Birth Date
          StitchTextField(
            controller: _birthDateController,
            label: context.tr('birth_date'),
            hintText: 'DD / MM / YYYY',
            prefixIcon: const Icon(
              Icons.calendar_month_outlined,
              color: AppColors.stitchPrimary,
            ),
            keyboardType: TextInputType.datetime,
            readOnly: true,
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(
                  const Duration(days: 365 * 18),
                ), // 18 years old default
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: AppColors.stitchPrimary,
                        onPrimary: Colors.white,
                        onSurface: AppColors.textPrimary,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                // easy_localization exports DateFormat
                String formattedDate = DateFormat(
                  'dd / MM / yyyy',
                ).format(pickedDate);
                setState(() {
                  _birthDateController.text = formattedDate;
                });
              }
            },
          ),

          20.ph,

          /// Gender Selection
          Text(
            context.tr('gender'),
            style: AppStyles.s14Bold.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
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
            isPassword: true,
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
                ? context.tr('small_password')
                : null,
          ),

          20.ph,

          /// Confirm Password
          StitchTextField(
            controller: _confirmPasswordController,
            label: context.tr('confirm_password'),
            hintText: '••••••••',
            isPassword: true,
            obscureText: _obscureConfirmPassword,
            prefixIcon: const Icon(
              Icons.lock_reset_rounded,
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
              if (value != _passwordController.text) {
                return context.tr('password_not_match');
              }
              return null;
            },
          ),

          40.ph,

          /// Register Button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Use _getFormattedPhone() to get phone without leading '0'
                  // e.g. '01022322745' -> '1022322745'
                  final formattedPhone = _getFormattedPhone();
                  debugPrint('Formatted phone for backend: $formattedPhone');
                  context.push(
                    AppRoutes.otpVerification,
                    extra: _emailController.text,
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
                context.tr('continue_btn'),
                style: AppStyles.s16SemiBold,
              ),
            ),
          ),

          24.ph,

          /// OR Divider
          Row(
            children: [
              const Expanded(
                child: Divider(color: AppColors.cardBorder, thickness: 1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  context.tr('or_continue_with'),
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

          32.ph,

          /// Social Auth Buttons
          SocialAuthButton(
            title: context.tr('continue_with_google'),
            icon: const Icon(
              Icons.g_mobiledata_rounded,
              color: Colors.red,
              size: 36,
            ),
            onTap: () => context.push(AppRoutes.completeProfile),
          ),

          16.ph,

          SocialAuthButton(
            title: context.tr('continue_with_facebook'),
            icon: const Icon(
              Icons.facebook_rounded,
              color: Colors.blue,
              size: 28,
            ),
            onTap: () => context.push(AppRoutes.completeProfile),
          ),

          24.ph,

          /// Login Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.tr('have_an_account'),
                style: AppStyles.s14Medium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  context.tr('login_action'),
                  style: AppStyles.s14Bold.copyWith(
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.stitchPrimary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.stitchPrimary : AppColors.cardBorder,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppStyles.s14Bold.copyWith(
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
