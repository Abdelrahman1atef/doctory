import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/services/alerts.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/more/cubit/more_cubit.dart';
import 'package:doctory/features/more/cubit/more_states.dart';
import 'package:doctory/features/more/presentation/widgets/delete_account_bottom_sheet.dart';
import 'package:doctory/features/more/presentation/widgets/logout_bottom_sheet.dart';
import 'package:doctory/features/more/presentation/widgets/more_option_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/extensions.dart';

class MoreOptionsSection extends StatelessWidget {
  const MoreOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MoreCubit>(),
      child: BlocListener<MoreCubit, MoreStates>(
        listener: (context, state) {
          if (state is LogoutLoadingState ||
              state is DeleteAccountLoadingState) {
            SmartDialog.showLoading();
          } else {
            SmartDialog.dismiss();
          }

          if (state is LogoutSuccessState) {
            context.go(AppRoutes.login);
          } else if (state is DeleteAccountSuccessState) {
            context.go(AppRoutes.login);
          } else if (state is DeleteAccountErrorState) {
            Alerts.snack(
              text: state.message,
              state: SnackState.failed,
            );
          }
        },
        child: Builder(
          builder: (context) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MoreOptionItem(
                    title: 'personal_profile'.tr(),
                    icon: Icons.person_outline_rounded,
                    onTap: () {
                      context.push(AppRoutes.profile);
                    },
                  ),
                  12.ph,
                  MoreOptionItem(
                    title: context.tr('community'),
                    icon: Icons.people_outline,
                    onTap: () {
                      context.push(AppRoutes.community);
                    },
                  ),
                  12.ph,
                  MoreOptionItem(
                    title: 'delete_account'.tr(),
                    icon: Icons.delete_outline_rounded,
                    textColor: AppColors.error,
                    iconColor: AppColors.error,
                    onTap: () async {
                      final confirmed = await DeleteAccountBottomSheet.show(
                        context,
                      );
                      if (confirmed == true && context.mounted) {
                        context.read<MoreCubit>().deleteAccount();
                      }
                    },
                  ),
                  const SizedBox(height: 4),
                  MoreOptionItem(
                    title: context.tr('logout'),
                    icon: Icons.logout_rounded,
                    textColor: AppColors.error,
                    iconColor: AppColors.error,
                    onTap: () async {
                      final confirmed = await LogoutBottomSheet.show(context);
                      if (confirmed == true && context.mounted) {
                        context.read<MoreCubit>().logout();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
