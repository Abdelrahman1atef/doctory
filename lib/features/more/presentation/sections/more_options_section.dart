import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/chat/router/chat_router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/more/cubit/more_cubit.dart';
import 'package:doctory/features/more/cubit/more_states.dart';
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
          if (state is LogoutLoadingState) {
            SmartDialog.showLoading();
          } else {
            SmartDialog.dismiss();
          }

          if (state is LogoutSuccessState) {
            context.go(AppRoutes.login);
          } else if (state is LogoutErrorState) {
            // Optional: Handle error during logout if any
          }
        },
        child: Builder(
          builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MoreOptionItem(
                  title: context.l10n('personal_profile'),
                  icon: Icons.person_outline_rounded,
                  onTap: () {
                    context.push(AppRoutes.profile);
                  },
                ),
                MoreOptionItem(
                  title: 'الرسائل',
                  icon: Icons.chat_bubble_outline_rounded,
                  onTap: () {
                    context.pushNamed(ChatRouterNames.conversationsList);
                  },
                ),
                MoreOptionItem(
                  title: context.tr('logout'),
                  icon: Icons.logout_rounded,
                  textColor: AppColors.error,
                  iconColor: AppColors.error,
                  onTap: () {
                    context.read<MoreCubit>().logout();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
