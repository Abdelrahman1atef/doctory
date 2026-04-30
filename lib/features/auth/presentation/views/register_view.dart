import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../sections/register_form_section.dart';
import '../widgets/register_header_widget.dart';

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
            const RegisterHeaderWidget(),

            const SizedBox(height: 60),

            /// Form Section
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 200),
              child: const RegisterFormSection(),
            ),
            kBottomNavigationBarHeight.ph,
          ],
        ),
      ),
    );
  }
}
