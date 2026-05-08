import 'package:doctory/core/services/alerts.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.navigationShell.currentIndex,
          onTap: _onItemTapped,
          selectedItemColor: AppColors.stitchPrimary,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
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
              icon: const Icon(Icons.people_outline),
              activeIcon: const Icon(Icons.people_rounded),
              label: context.tr('community'),
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
