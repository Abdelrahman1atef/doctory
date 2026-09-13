import 'package:doctory/core/common/models/role.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/services/alerts.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/admin/router/admin_router_names.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_typography.dart';

class LayoutView extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const LayoutView({super.key, required this.navigationShell});

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  DateTime? _lastBackPressedTime;

  void _onItemTapped(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // 1. If we are not on the Home tab, go to Home tab first
        if (widget.navigationShell.currentIndex != 0) {
          widget.navigationShell.goBranch(0);
          return;
        }

        // 2. If we are on Home tab, implement "Double back to exit"
        final now = DateTime.now();
        if (_lastBackPressedTime == null ||
            now.difference(_lastBackPressedTime!) >
                const Duration(seconds: 2)) {
          _lastBackPressedTime = now;

          // Show toast/snackbar to inform user
          Alerts.snack(
            text: LocaleKeys.press_back_again_to_exit.tr(),
            state: SnackState.success,
          );
          return;
        }

        // If pressed again within 2 seconds, close the app
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: widget.navigationShell,
        floatingActionButton: ValueListenableBuilder(
          valueListenable: UserSession.userNotifier,
          builder: (context, user, child) {
            final isClinicOrAdmin = UserSession.currentRole == UserRole.clinicOwner ||
                UserSession.currentRole == UserRole.superAdmin;
            
            if (!isClinicOrAdmin) return const SizedBox.shrink();

            return FloatingActionButton(
              heroTag: 'layout_fab',
              onPressed: () => context.push(
                UserSession.currentRole == UserRole.superAdmin
                    ? AdminRoutes.admin
                    : AppRoutes.clinicDashboard,
              ),
              backgroundColor: AppColors.stitchPrimary,
              foregroundColor: AppColors.white,
              child: Icon(
                UserSession.currentRole == UserRole.superAdmin
                    ? Icons.admin_panel_settings_rounded
                    : Icons.dashboard_rounded,
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.navigationShell.currentIndex,
          onTap: _onItemTapped,
          selectedItemColor: AppColors.stitchPrimary,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle:  AppStyles.s12Bold.withColor(AppColors.textPrimary),
          unselectedLabelStyle:  AppStyles.s12Medium.withColor(AppColors.textPrimary),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_rounded),
              label: context.tr('home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.map_outlined),
              activeIcon: const Icon(Icons.map_rounded),
              label: context.tr('map.title'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_month_outlined),
              activeIcon: const Icon(Icons.calendar_month_rounded),
              label: context.tr('my_appointments'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              activeIcon: const Icon(Icons.chat_bubble_rounded),
              label: context.tr('chat'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.more_horiz_outlined),
              activeIcon: const Icon(Icons.more_horiz_rounded),
              label: context.tr('more'),
            ),
          ],
        ),
      ),
    );
  }
}
