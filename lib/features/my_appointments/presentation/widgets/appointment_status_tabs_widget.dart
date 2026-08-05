import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/booking/domain/enums/appointment_status.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppointmentStatusTabsWidget extends StatelessWidget {
  final AppointmentStatus selected;
  final ValueChanged<AppointmentStatus> onSelected;

  const AppointmentStatusTabsWidget({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const List<_TabConfig> _tabs = [
    _TabConfig('pending', AppointmentStatus.pending),
    _TabConfig('awaiting_payment', AppointmentStatus.accepted),
    _TabConfig('confirmed', AppointmentStatus.confirmed),
    _TabConfig('completed', AppointmentStatus.completed),
    _TabConfig('cancelled', AppointmentStatus.cancelled),
    _TabConfig('rejected', AppointmentStatus.rejected),
  ];

  int get _selectedTabIndex {
    final idx = _tabs.indexWhere((t) => t.status == selected);
    return idx >= 0 ? idx : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(4),
        children: [
          for (int i = 0; i < _tabs.length; i++)
            _buildTab(context, i, _tabs[i].label.tr()),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, int index, String label) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        if (_selectedTabIndex != index) {
          onSelected(_tabs[index].status);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.stitchPrimaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: AppStyles.s14Medium.copyWith(
              color: isSelected
                  ? AppColors.stitchSurfaceLowest
                  : AppColors.stitchSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _TabConfig {
  final String label;
  final AppointmentStatus status;

  const _TabConfig(this.label, this.status);
}