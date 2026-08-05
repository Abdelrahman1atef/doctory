import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';
import 'package:doctory/features/booking/domain/enums/appointment_status.dart';
import 'package:doctory/features/my_appointments/presentation/widgets/appointment_card_widget.dart';
import 'package:doctory/features/my_appointments/presentation/widgets/appointment_status_tabs_widget.dart';
import 'package:doctory/features/my_appointments/presentation/widgets/empty_appointments_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyAppointmentsListSection extends StatefulWidget {
  final List<AppointmentResponseDto> appointments;
  final bool hasMore;
  final bool isLoadingMore;
  final AppointmentStatus? statusFilter;
  final VoidCallback onLoadMore;
  final void Function(AppointmentStatus status) onLoadByStatus;
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

  Future<void> _openDetails(
    BuildContext context,
    AppointmentResponseDto apt,
  ) async {
    await context.push(
      '${AppRoutes.appointmentDetails}?id=${apt.id}',
    );
    if (!context.mounted) return;
    widget.onLoadByStatus(widget.statusFilter ?? AppointmentStatus.pending);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppointmentStatusTabsWidget(
            selected: widget.statusFilter ?? AppointmentStatus.pending,
            onSelected: widget.onLoadByStatus,
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
                    child: const Center(child: EmptyAppointmentsWidget()),
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
                itemCount: widget.appointments.length +
                    (widget.isLoadingMore ? 1 : 0),
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
                  final showPay = apt.appointmentStatus ==
                          AppointmentStatus.accepted &&
                      apt.paymobRedirectUrl != null;
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
}