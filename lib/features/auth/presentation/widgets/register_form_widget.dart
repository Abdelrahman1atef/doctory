import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/common/models/specialty_model.dart';
import '../../../../core/common/widgets/buttons/social_auth_button.dart';
import '../../../../core/common/widgets/images/profile_image_picker.dart';
import '../../../../core/common/widgets/inputs/stitch_text_field.dart';
import '../../../../core/common/widgets/inputs/stitch_upload_field.dart';
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
  final TextEditingController bioController;
  final TextEditingController yearsOfExperienceController;
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
  final bool isDoctor;
  final bool requireBioFields;
  final String? practiceCardFileName;
  final String? unionFileName;
  final String? taxCardFileName;
  final File? profileImage;
  final VoidCallback? onPickPracticeCard;
  final VoidCallback? onPickUnion;
  final VoidCallback? onPickTaxCard;
  final ValueChanged<File?>? onPickProfileImage;
  final List<SpecialtyModel>? specializations;
  final String? selectedSpecializationId;
  final ValueChanged<String?>? onSpecializationChanged;

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
    this.isDoctor = false,
    this.requireBioFields = false,
    this.practiceCardFileName,
    this.unionFileName,
    this.taxCardFileName,
    this.profileImage,
    this.onPickPracticeCard,
    this.onPickUnion,
    this.onPickTaxCard,
    this.onPickProfileImage,
    this.specializations,
    this.selectedSpecializationId,
    this.onSpecializationChanged,
    required this.bioController,
    required this.yearsOfExperienceController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Profile Image (doctors only)
          if (onPickProfileImage != null) ...[
            Center(
              child: ProfileImagePicker(
                imageFile: profileImage,
                onImagePicked: onPickProfileImage!,
              ),
            ),
            24.ph,
          ],

          /// Full Name
          StitchTextField(
            controller: nameController,
            label: context.l10n('full_name'),
            hintText: 'John Doe',
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.stitchPrimary,
            ),
            validator: (value) {
              if (requireBioFields && (value == null || value.trim().isEmpty)) {
                return context.l10n('field_required');
              }
              return null;
            },
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
              if (requireBioFields && (value == null || value.trim().isEmpty)) {
                return context.l10n('field_required');
              }
              return null;
            },
          ),

          20.ph,

          /// Phone Number
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
              if (requireBioFields && (value == null || value.trim().isEmpty)) {
                return context.l10n('field_required');
              }
              if (requireBioFields && value != null && value.trim().length != 11) {
                return context.l10n('invalid_phone');
              }
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
                if (requireBioFields)
                  TextSpan(
                    text: ' *',
                    style: AppStyles.s14Bold.copyWith(color: Colors.red),
                  )
                else
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
                  isRequired: requireBioFields,
                  validator: (value) {
                    if (requireBioFields && (value == null || value.isEmpty)) {
                      return context.l10n('field_required');
                    }
                    if (value == null || value.isEmpty) return null;
                    final day = int.tryParse(value);
                    if (day == null || day < 1 || day > 31) {
                      return '';
                    }
                    final month = int.tryParse(monthController.text);
                    final year = int.tryParse(yearController.text);
                    if (month != null && year != null) {
                      final daysInMonth = DateTime(year, month + 1, 0).day;
                      if (day > daysInMonth) return '';
                      final date = DateTime(year, month, day);
                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);
                      if (!date.isBefore(today)) return '';
                      final minAge = DateTime(now.year - 18, now.month, now.day);
                      if (date.isAfter(minAge)) return '';
                    }
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
                  isRequired: requireBioFields,
                  validator: (value) {
                    if (requireBioFields && (value == null || value.isEmpty)) {
                      return context.l10n('field_required');
                    }
                    if (value == null || value.isEmpty) return null;
                    final month = int.tryParse(value);
                    if (month == null || month < 1 || month > 12) {
                      return '';
                    }
                    final day = int.tryParse(dayController.text);
                    final year = int.tryParse(yearController.text);
                    if (day != null && year != null) {
                      final daysInMonth = DateTime(year, month + 1, 0).day;
                      if (day > daysInMonth) return '';
                      final date = DateTime(year, month, day);
                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);
                      if (!date.isBefore(today)) return '';
                      final minAge = DateTime(now.year - 18, now.month, now.day);
                      if (date.isAfter(minAge)) return '';
                    }
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
                  isRequired: requireBioFields,
                  validator: (value) {
                    if (requireBioFields && (value == null || value.isEmpty)) {
                      return context.l10n('field_required');
                    }
                    if (value == null || value.isEmpty) return null;
                    if (value.length != 4) return '';
                    final year = int.tryParse(value);
                    if (year == null || year < 1900 || year > DateTime.now().year) {
                      return '';
                    }
                    final day = int.tryParse(dayController.text);
                    final month = int.tryParse(monthController.text);
                    if (day != null && month != null) {
                      final daysInMonth = DateTime(year, month + 1, 0).day;
                      if (day > daysInMonth) return '';
                      final date = DateTime(year, month, day);
                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);
                      if (!date.isBefore(today)) return '';
                      final minAge = DateTime(now.year - 18, now.month, now.day);
                      if (date.isAfter(minAge)) return '';
                    }
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
            isRequired: requireBioFields,
          ),

          20.ph,

          /// Doctor Upload Fields
          if (onPickPracticeCard != null) ...[
            StitchUploadField(
              label: context.l10n('professional_practice_card_label'),
              fileName: practiceCardFileName,
              hint: context.l10n('upload_file_hint'),
              isRequired: true,
              onPick: onPickPracticeCard!,
            ),
            12.ph,
          ],

          if (onPickUnion != null) ...[
            StitchUploadField(
              label: context.l10n('union_id_card_label'),
              fileName: unionFileName,
              hint: context.l10n('upload_file_hint'),
              isRequired: true,
              onPick: onPickUnion!,
            ),
            12.ph,
          ],

          if (onPickTaxCard != null) ...[
            StitchUploadField(
              label: context.l10n('tax_card_label'),
              fileName: taxCardFileName,
              hint: context.l10n('upload_file_hint'),
              isRequired: true,
              onPick: onPickTaxCard!,
            ),
            12.ph,
          ],

          if (isDoctor) ...[
            /// Password + Confirm Password side by side for doctors
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
                    validator: (value) {
                      if (requireBioFields && (value == null || value.length < 6)) {
                        return context.l10n('password_too_short');
                      }
                      return null;
                    },
                  ),
                12.ph,
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
                      if (requireBioFields && value != passwordController.text) {
                        return context.l10n('passwords_dont_match');
                      }
                      return null;
                    },
                  ),
          ] else ...[
            /// Password (stacked for patients)
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
              validator: (value) {
                if (requireBioFields && (value == null || value.length < 6)) {
                  return context.l10n('password_too_short');
                }
                return null;
              },
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
                if (requireBioFields && value != passwordController.text) {
                  return context.l10n('passwords_dont_match');
                }
                return null;
              },
            ),
          ],

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

          /// Social Registration — user only
          if (!isDoctor) ...[
            24.ph,

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