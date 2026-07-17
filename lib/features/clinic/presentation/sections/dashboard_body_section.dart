import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/common/widgets/error/app_error_widget.dart';
import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/clinic/cubit/clinic_dashboard_cubit.dart';
import 'package:doctory/features/clinic/cubit/clinic_dashboard_state.dart';
import 'package:doctory/features/clinic/data/model/booking_request_model.dart';
import 'package:doctory/features/clinic/presentation/sections/dashboard_appbar_section.dart';
import 'package:doctory/features/clinic/presentation/sections/dashboard_stats_section.dart';
import 'package:doctory/features/clinic/presentation/sections/dashboard_period_stats_section.dart';
import 'package:doctory/features/clinic/presentation/widgets/booking_request_card_widget.dart';
import 'package:doctory/features/clinic/presentation/widgets/dashboard_empty_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class DashboardBodySection extends StatefulWidget {
  const DashboardBodySection({super.key});

  @override
  State<DashboardBodySection> createState() => _DashboardBodySectionState();
}

class _DashboardBodySectionState extends State<DashboardBodySection> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<ClinicDashboardCubit>();
    final state = cubit.state;
    if (state is! ClinicDashboardLoaded) return;
    if (state.isLoadingMore || !state.hasMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      cubit.loadMoreBookings();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicDashboardCubit, ClinicDashboardState>(
      builder: (context, state) {
        final unreadCount = state is ClinicDashboardLoaded ? state.unreadCount : 0;

        if (state is ClinicDashboardLoading) {
          return Column(
            children: [
              DashboardAppbarSection(unreadCount: unreadCount),
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }

        if (state is ClinicDashboardError) {
          return Column(
            children: [
              DashboardAppbarSection(unreadCount: unreadCount),
              Expanded(child: AppErrorWidget(message: state.message)),
            ],
          );
        }

        if (state is! ClinicDashboardLoaded) {
          return const SizedBox.shrink();
        }

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(child: DashboardAppbarSection(unreadCount: state.unreadCount)),
            const SliverToBoxAdapter(child: DashboardStatsSection()),
            const SliverToBoxAdapter(child: DashboardPeriodStatsSection()),
            SliverToBoxAdapter(child: _StatusFilterSection(state: state)),
            if (state.bookings.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: DashboardEmptyWidget(icon: Icons.check_circle_outline),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final booking = state.bookings[index];
                    return BookingRequestCardWidget(
                      booking: booking,
                      onAccept: state.currentStatus == BookingStatus.pending
                          ? () => context.read<ClinicDashboardCubit>().acceptBooking(booking.id)
                          : null,
                      onReject: state.currentStatus == BookingStatus.pending
                          ? () => context.read<ClinicDashboardCubit>().rejectBooking(booking.id)
                          : null,
                    );
                  },
                  childCount: state.bookings.length,
                ),
              ),
            if (state.isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        );
      },
    );
  }
}

class _StatusFilterSection extends StatelessWidget {
  final ClinicDashboardLoaded state;

  const _StatusFilterSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          _FilterChip(
            label: '${LocaleKeys.pending.tr()} (${state.pendingCount})',
            isSelected: state.currentStatus == BookingStatus.pending,
            onTap: () => context.read<ClinicDashboardCubit>().switchStatus(BookingStatus.pending),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: '${LocaleKeys.accepted.tr()} (${state.acceptedCount})',
            isSelected: state.currentStatus == BookingStatus.accepted,
            onTap: () => context.read<ClinicDashboardCubit>().switchStatus(BookingStatus.accepted),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: '${LocaleKeys.rejected.tr()} (${state.rejectedCount})',
            isSelected: state.currentStatus == BookingStatus.rejected,
            onTap: () => context.read<ClinicDashboardCubit>().switchStatus(BookingStatus.rejected),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.stitchPrimary : AppColors.stitchSurfaceLow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppStyles.s13Medium.withColor(
              isSelected ? AppColors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
