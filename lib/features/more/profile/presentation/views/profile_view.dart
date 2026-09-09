import 'package:doctory/features/more/profile/presentation/sections/profile_body_section.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('personal_profile'.tr(),style: AppStyles.s20SemiBold.withColor(AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: ProfileBodySection(),
      ),
    );
  }
}
