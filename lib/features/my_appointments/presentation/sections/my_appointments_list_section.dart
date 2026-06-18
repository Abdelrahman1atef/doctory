import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';
import 'package:doctory/features/my_appointments/presentation/widgets/appointment_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctory/core/router/router_names.dart';

class MyAppointmentsListSection extends StatefulWidget {
  final List<AppointmentResponseDto> appointments;

  const MyAppointmentsListSection({super.key, required this.appointments});

  @override
  State<MyAppointmentsListSection> createState() => _MyAppointmentsListSectionState();
}

class _MyAppointmentsListSectionState extends State<MyAppointmentsListSection> {
  int _selectedTab = 0;

  List<AppointmentResponseDto> get _filtered {
    switch (_selectedTab) {
      case 0:
        return widget.appointments
            .where((a) => a.status == 'pending' || a.status == 'reserved' || a.status == 'confirmed')
            .toList()
          ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
      case 1:
        return widget.appointments
            .where((a) => a.status == 'completed')
            .toList()
          ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
      case 2:
        return widget.appointments
            .where((a) => a.status == 'cancelled')
            .toList()
          ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
      default:
        return widget.appointments;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.stitchSurfaceLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _tab(0, 'current'.tr()),
                _tab(1, 'last'.tr()),
                _tab(2, 'canceled'.tr()),
              ],
            ),
          ),
        ),
        16.ph,
        if (filtered.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.event_busy_rounded, size: 64, color: AppColors.grey400),
                  16.ph,
                  Text('no_appointments'.tr(),
                    style: AppStyles.s16Medium.withColor(AppColors.stitchSecondary)),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final apt = filtered[index];
                return AppointmentCardWidget(
                  appointment: apt,
                  onTap: () => context.push(AppRoutes.appointmentDetails, extra: apt),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _tab(int index, String label) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.stitchPrimaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(label,
              style: AppStyles.s14Medium.copyWith(
                color: isSelected ? AppColors.stitchSurfaceLowest : AppColors.stitchSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              )),
          ),
        ),
      ),
    );
  }
}
