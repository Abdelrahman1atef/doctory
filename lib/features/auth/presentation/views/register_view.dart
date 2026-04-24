import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/auth/presentation/sections/register_form_section.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_typography.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stitchSurface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const BackButton(color: AppColors.stitchPrimary),
              forceMaterialTransparency: true,
            ),
            const SizedBox(height: 10),

            /// Header Section
            FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: Column(
                children: [
                  Text(
                    context.tr('signUp'),
                    textAlign: TextAlign.center,
                    style: AppStyles.s14Bold.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.stitchPrimary,
                      fontSize: 32,
                      height: 1.2,
                    ),
                  ),
                  12.ph,
                  Text(
                    context.tr('signUp_subtitle'),
                    textAlign: TextAlign.center,
                    style: AppStyles.s14Bold.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            /// Form Section
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 200),
              child: const RegisterFormSection(),
            ),
            kBottomNavigationBarHeight.ph
          ],
        ),
      ),
    );
  }
}
