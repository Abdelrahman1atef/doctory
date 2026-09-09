import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/services/alerts.dart';
import 'package:doctory/features/more/cubit/more_cubit.dart';
import 'package:doctory/features/more/cubit/more_states.dart';
import 'package:doctory/features/more/presentation/widgets/delete_account_bottom_sheet.dart';
import 'package:doctory/features/more/presentation/widgets/logout_bottom_sheet.dart';
import 'package:doctory/features/more/presentation/widgets/more_options_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

class MoreOptionsSection extends StatelessWidget {
  const MoreOptionsSection({super.key});

  void _onState(BuildContext context, MoreStates state) {
    switch (state) {
      case LogoutLoadingState() || DeleteAccountLoadingState():
        SmartDialog.showLoading();
      case LogoutSuccessState() || DeleteAccountSuccessState():
        SmartDialog.dismiss();
        context.go(AppRoutes.login);
      case LogoutErrorState(:final message) ||
          DeleteAccountErrorState(:final message):
        SmartDialog.dismiss();
        Alerts.snack(text: message, state: SnackState.failed);
      case MoreInitialState():
        SmartDialog.dismiss();
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirmed = await DeleteAccountBottomSheet.show(context);
    if (confirmed != true || !context.mounted) return;
    context.read<MoreCubit>().deleteAccount();
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final bool? confirmed = await LogoutBottomSheet.show(context);
    if (confirmed != true || !context.mounted) return;
    context.read<MoreCubit>().logout();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MoreCubit, MoreStates>(
      listener: _onState,
      child: MoreOptionsListWidget(
        onProfileTap: () => context.push(AppRoutes.profile),
        onCommunityTap: () => context.push(AppRoutes.community),
        onDeleteAccountTap: () => _confirmDelete(context),
        onLogoutTap: () => _confirmLogout(context),
      ),
    );
  }
}
