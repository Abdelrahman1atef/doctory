import 'dart:io';

import 'package:doctory/core/app_strings/app_strings.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ImagePickerWidget extends StatelessWidget {
  final String? imagePath;

  final VoidCallback onTap;

  final double radius;

  final Color? backgroundColor;

  final String? description;
  final String? optionalText;
  const ImagePickerWidget({
    super.key,
    required this.imagePath,
    required this.onTap,
    this.radius = 50,
    this.backgroundColor,
    this.description,
    this.optionalText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: radius,
                  backgroundColor: backgroundColor ?? AppColors.lightWhite,
                  backgroundImage: imagePath != null
                      ? FileImage(File(imagePath!))
                      : null,
                  child: imagePath == null
                      ? Icon(
                          Icons.person,
                          size: radius * 0.8,
                          color: AppColors.grey4,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: radius * 0.28,
                    backgroundColor: AppColors.primaryTeal,
                    child: Icon(
                      Icons.camera_alt,
                      size: radius * 0.28,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          16.ph,

          Text(
            optionalText ?? AppStrings.profileImageOptional.tr(),
            textAlign: TextAlign.center,
            style: AppStyles.s14Medium.withColor(AppColors.primaryNavy),
          ),

          4.ph,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              description ?? AppStrings.profileImageDescription.tr(),
              textAlign: TextAlign.center,
              style: AppStyles.s12Medium.withColor(AppColors.grey6),
            ),
          ),
        ],
      ),
    );
  }
}
