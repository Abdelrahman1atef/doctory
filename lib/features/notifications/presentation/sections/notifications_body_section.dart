import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/notifications/cubit/notifications_cubit.dart';
import 'package:doctory/features/notifications/cubit/notifications_state.dart';
import 'package:doctory/features/notifications/presentation/sections/notifications_list_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NotificationsBodySection extends StatelessWidget {
  const NotificationsBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        if (state is NotificationsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: AppColors.stitchPrimaryContainer),
                    onPressed: () => context.pop(),
                  ),
                  const Spacer(),
                  Text(
                    LocaleKeys.notifications_title.tr(),
                    style: AppStyles.s20Bold.withColor(AppColors.stitchPrimaryContainer),
                  ),
                  const Spacer(),
                  if (state is NotificationsLoaded && state.notifications.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.delete_sweep_rounded,
                          color: AppColors.stitchPrimaryContainer),
                      onPressed: () => _confirmDeleteAll(context),
                    )
                  else
                    const SizedBox(width: 48),
                ],
              ),
            ),
            8.ph,
            Expanded(
              child: _buildBody(context, state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, NotificationsState state) {
    if (state is NotificationsLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.stitchPrimaryContainer),
      );
    }
    if (state is NotificationsError) {
      return Center(
        child: Text(state.message, style: AppStyles.s14Medium.withColor(AppColors.error)),
      );
    }
    if (state is NotificationsLoaded) {
      return NotificationsListSection(
        notifications: state.notifications,
        onMarkAsRead: (id) => context.read<NotificationsCubit>().markAsRead(id),
        onDelete: (id) => context.read<NotificationsCubit>().deleteNotification(id),
        onTap: (id) {
          context.read<NotificationsCubit>().markAsRead(id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.notifications.firstWhere((n) => n.id == id).title.tr()),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  void _confirmDeleteAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(LocaleKeys.notification_delete_all_title.tr()),
        content: Text(LocaleKeys.notification_delete_all_description.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<NotificationsCubit>().deleteAll();
            },
            child: Text(
              LocaleKeys.notification_delete_all_confirm.tr(),
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
