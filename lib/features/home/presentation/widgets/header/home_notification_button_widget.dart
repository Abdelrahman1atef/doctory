import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_spacing.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Notification bell with an unread-count badge.
class HomeNotificationButtonWidget extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const HomeNotificationButtonWidget({
    super.key,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onTap,
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
          ),
        ),
        if (unreadCount > 0)
          PositionedDirectional(
            end: AppSpacing.s6,
            top: AppSpacing.s6,
            child: _UnreadBadge(count: unreadCount),
          ),
      ],
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  final int count;

  const _UnreadBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(AppSpacing.r10),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: AppStyles.s10Bold.copyWith(color: AppColors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
