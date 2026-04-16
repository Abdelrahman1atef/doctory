import 'package:doctory/core/common/widgets/buttons/abher_button.dart';
import 'package:doctory/core/common/widgets/sheets/abher_sheet.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RequireAuthBottomSheet extends StatelessWidget {
  const RequireAuthBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return AbherSheet(
      icon: 'require_auth',
      title: 'require_auth.title'.tr(),
      description: 'require_auth.sub'.tr(),
      primaryButtonText: 'require_auth.continue'.tr(),
      onPrimaryPressed: () => context.push(AppRoutes.login),
      secondaryButtonText: 'require_auth.cancel'.tr(),
      secondaryButtonVariant: AbherButtonVariant.ghost,
      onSecondaryPressed: context.pop,
    );
  }
}
