import 'dart:io';

import 'package:doctory/core/theme/app_spacing.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/more/profile/presentation/widgets/profile_form_widget.dart';
import 'package:doctory/features/more/profile/presentation/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';

/// Scrollable layout of the profile screen: avatar picker above the form.
class ProfileFormLayoutWidget extends StatelessWidget {
  final String? imageUrl;
  final File? pickedImage;
  final VoidCallback onPickImage;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;
  final VoidCallback onSubmit;
  final bool isSaveEnabled;

  const ProfileFormLayoutWidget({
    super.key,
    required this.onPickImage,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.dayController,
    required this.monthController,
    required this.yearController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.onSubmit,
    required this.isSaveEnabled,
    this.imageUrl,
    this.pickedImage,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: AppSpacing.s24,
        right: AppSpacing.s24,
        top: AppSpacing.s24,
        bottom: context.bottomPadding,
      ),
      child: Column(
        children: [
          ProfileImageWidget(
            imageUrl: imageUrl,
            localImage: pickedImage,
            onPickImage: onPickImage,
          ),
          32.ph,
          ProfileFormWidget(
            formKey: formKey,
            nameController: nameController,
            phoneController: phoneController,
            dayController: dayController,
            monthController: monthController,
            yearController: yearController,
            selectedGender: selectedGender,
            onGenderChanged: onGenderChanged,
            onSubmit: onSubmit,
            isSaveEnabled: isSaveEnabled,
          ),
        ],
      ),
    );
  }
}
