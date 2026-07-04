import 'package:animate_do/animate_do.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';

/// Pure widget — displays the Register screen layout
/// (AppBar + header + form) with animations.
class RegisterBodyWidget extends StatelessWidget {
  final Widget header;
  final Widget form;
  final bool showBackButton;
  final VoidCallback? onBack;

  const RegisterBodyWidget({
    super.key,
    required this.header,
    required this.form,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: showBackButton && onBack != null
                ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.stitchPrimary),
                    onPressed: onBack,
                  )
                : const BackButton(color: AppColors.stitchPrimary),
            forceMaterialTransparency: true,
          ),
          const SizedBox(height: 10),
          header,
          const SizedBox(height: 60),
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 200),
            child: form,
          ),
          kBottomNavigationBarHeight.ph,
        ],
      ),
    );
  }
}
