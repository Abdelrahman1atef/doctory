import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/more/presentation/widgets/more_option_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Pure UI list of the "More" tab entries. Callbacks out, no cubit access.
class MoreOptionsListWidget extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onCommunityTap;
  final VoidCallback onDeleteAccountTap;
  final VoidCallback onLogoutTap;

  const MoreOptionsListWidget({
    super.key,
    required this.onProfileTap,
    required this.onCommunityTap,
    required this.onDeleteAccountTap,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: context.bottomPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MoreOptionItem(
            title: 'personal_profile'.tr(),
            icon: Icons.person_outline_rounded,
            onTap: onProfileTap,
          ),
          12.ph,
          MoreOptionItem(
            title: 'community'.tr(),
            icon: Icons.people_outline,
            onTap: onCommunityTap,
          ),
          12.ph,
          MoreOptionItem(
            title: 'delete_account'.tr(),
            icon: Icons.delete_outline_rounded,
            textColor: AppColors.error,
            iconColor: AppColors.error,
            onTap: onDeleteAccountTap,
          ),
          4.ph,
          MoreOptionItem(
            title: 'logout'.tr(),
            icon: Icons.logout_rounded,
            textColor: AppColors.error,
            iconColor: AppColors.error,
            onTap: onLogoutTap,
          ),
        ],
      ),
    );
  }
}
