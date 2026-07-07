import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/more/profile/presentation/sections/profile_body_section.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n('personal_profile'),style: AppStyles.s20SemiBold.withColor(AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: ProfileBodySection(),
      ),
    );
  }
}
