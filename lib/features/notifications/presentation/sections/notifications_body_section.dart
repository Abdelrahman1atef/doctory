import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/enums/notification_type.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/services/alerts.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/chat/data/repo/chat_repo.dart';
import 'package:doctory/features/chat/router/chat_router_names.dart';
import 'package:doctory/features/notifications/cubit/notifications_cubit.dart';
import 'package:doctory/features/notifications/cubit/notifications_state.dart';
import 'package:doctory/features/notifications/data/model/notification_model.dart';
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
          Alerts.snack(text: state.message, state: SnackState.failed);
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
      return RefreshIndicator(
        onRefresh: () => context.read<NotificationsCubit>().loadNotifications(),
        color: AppColors.stitchPrimaryContainer,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 300,
            child: Center(
              child: Text(state.message, style: AppStyles.s14Medium.withColor(AppColors.error)),
            ),
          ),
        ),
      );
    }
    if (state is NotificationsLoaded) {
      return RefreshIndicator(
        onRefresh: () => context.read<NotificationsCubit>().loadNotifications(),
        color: AppColors.stitchPrimaryContainer,
        child: NotificationsListSection(
          notifications: state.notifications,
          onTap: (notification) => _handleNotificationTap(context, notification),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _handleNotificationTap(BuildContext context, NotificationModel notification) {
    switch (notification.type) {
      case NotificationType.newMessage:
        final userId = notification.senderUserId ?? notification.userId;
        _openChatRoom(context, userId);
      case NotificationType.appointmentReminder:
      case NotificationType.appointmentConfirmation:
      case NotificationType.appointmentCancellation:
        final appointmentId = notification.appointmentId;
        if (appointmentId != null && appointmentId.isNotEmpty) {
          context.push('${AppRoutes.appointmentDetails}?id=$appointmentId');
        } else {
          context.pushNamed(AppRoutes.myAppointments);
        }
      case NotificationType.paymentConfirmation:
        context.pushNamed(AppRoutes.myAppointments);
      case NotificationType.systemAnnouncement:
        break;
      case null:
        break;
    }
  }

  Future<void> _openChatRoom(BuildContext context, String userId) async {
    final repo = sl<ChatRepo>();
    final result = await repo.createConversation(userId);
    result.fold(
      onSuccess: (conversationId) {
        if (context.mounted) {
          context.pushNamed(
            ChatRouterNames.chatRoom,
            pathParameters: {'id': conversationId},
          );
        }
      },
      onFailure: (failure) {
        if (context.mounted) {
          Alerts.snack(text: failure.message, state: SnackState.failed);
        }
      },
    );
  }
}
