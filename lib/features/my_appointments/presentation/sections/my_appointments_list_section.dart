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
  final bool hasMore;
  final bool isLoadingMore;
  final int? statusFilter;
  final VoidCallback onLoadMore;
  final void Function(int status) onLoadByStatus;
  final void Function(AppointmentResponseDto appointment) onPayTap;
  final Future<void> Function() onRefresh;

  const MyAppointmentsListSection({
    super.key,
    required this.appointments,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.statusFilter,
    required this.onLoadMore,
    required this.onLoadByStatus,
    required this.onPayTap,
    required this.onRefresh,
  });

  @override
  State<MyAppointmentsListSection> createState() =>
      _MyAppointmentsListSectionState();
}

class _MyAppointmentsListSectionState extends State<MyAppointmentsListSection> {
  final ScrollController _scrollController = ScrollController();

  static const List<_TabConfig> _tabs = [
    _TabConfig('pending', 0),
    _TabConfig('awaiting_payment', 6),
    _TabConfig('confirmed', 1),
    _TabConfig('completed', 3),
    _TabConfig('cancelled', 2),
    _TabConfig('rejected', 7),
  ];

  int get _selectedTabIndex {
    final idx = _tabs.indexWhere((t) => t.status == widget.statusFilter);
    return idx >= 0 ? idx : 0;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.onLoadMore();
    }
  }

  Future<void> _openDetails(BuildContext context, AppointmentResponseDto apt) async {
    await context.push(
      '${AppRoutes.appointmentDetails}?id=${apt.id}',
    );
    if (!context.mounted) return;
    widget.onLoadByStatus(widget.statusFilter ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
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
                  _tab(i, _tabs[i].label.tr()),
              ],
            ),
          ),
        ),
        16.ph,
        if (widget.appointments.isEmpty && !widget.isLoadingMore)
          Expanded(
            child: RefreshIndicator(
              onRefresh: widget.onRefresh,
              color: AppColors.stitchPrimaryContainer,
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.event_busy_rounded,
                            size: 64,
                            color: AppColors.grey400,
                          ),
                          16.ph,
                          Text(
                            'no_appointments'.tr(),
                            style: AppStyles.s16Medium.withColor(
                              AppColors.stitchSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: widget.onRefresh,
              color: AppColors.stitchPrimaryContainer,
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                itemCount:
                    widget.appointments.length + (widget.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == widget.appointments.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  }
                  final apt = widget.appointments[index];
                  final showPay =
                      apt.status == 6 && apt.paymobRedirectUrl != null;
                  return AppointmentCardWidget(
                    appointment: apt,
                    onTap: () => _openDetails(context, apt),
                    onPayTap: showPay ? () => widget.onPayTap(apt) : null,
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _tab(int index, String label) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        if (_selectedTabIndex != index) {
          widget.onLoadByStatus(_tabs[index].status);
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
  final int status;
  const _TabConfig(this.label, this.status);
}
