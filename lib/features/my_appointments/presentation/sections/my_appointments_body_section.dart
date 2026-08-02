import 'package:doctory/core/common/widgets/layout/abher_payment_webview.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';
import 'package:doctory/features/my_appointments/cubit/my_appointments_cubit.dart';
import 'package:doctory/features/my_appointments/cubit/my_appointments_state.dart';
import 'package:doctory/features/my_appointments/presentation/sections/my_appointments_list_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppointmentsBodySection extends StatefulWidget {
  const MyAppointmentsBodySection({super.key});

  @override
  State<MyAppointmentsBodySection> createState() => _MyAppointmentsBodySectionState();
}

class _MyAppointmentsBodySectionState extends State<MyAppointmentsBodySection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Row(
            children: [
              const Spacer(),
              Text('my_appointments'.tr(),
                style: AppStyles.s20Bold.withColor(AppColors.stitchPrimaryContainer)),
              const Spacer(),
            ],
          ),
        ),
        8.ph,
        Expanded(
          child: BlocConsumer<MyAppointmentsCubit, MyAppointmentsState>(
            listener: (context, state) {
              if (state is MyAppointmentsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
                );
              }
            },
            builder: (context, state) {
              if (state is MyAppointmentsLoading) {
                return const Center(child: CircularProgressIndicator(
                  color: AppColors.stitchPrimaryContainer));
              }
              if (state is MyAppointmentsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message,
                        style: AppStyles.s14Medium.withColor(AppColors.error)),
                      16.ph,
                      TextButton(
                        onPressed: () => context.read<MyAppointmentsCubit>().loadAppointments(),
                        child: Text('try_again'.tr()),
                      ),
                    ],
                  ),
                );
              }
              if (state is MyAppointmentsLoaded) {
                return _buildList(context, state);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context, MyAppointmentsLoaded state) {
    return Stack(
      children: [
        MyAppointmentsListSection(
          appointments: state.appointments,
          hasMore: state.hasMore,
          isLoadingMore: state.isLoadingMore,
          statusFilter: state.statusFilter,
          onLoadMore: () => context.read<MyAppointmentsCubit>().loadMore(),
          onLoadByStatus: (status) =>
              context.read<MyAppointmentsCubit>().loadByStatus(status),
          onPayTap: (appointment) =>
              _openPaymentWebView(context, appointment),
          onRefresh: () => context.read<MyAppointmentsCubit>().refresh(),
        ),
        if (state.isRefreshing)
          const Positioned.fill(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Future<void> _openPaymentWebView(
    BuildContext context,
    AppointmentResponseDto appointment,
  ) async {
    final url = appointment.paymobRedirectUrl;
    if (url == null || url.isEmpty) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AbherPaymentWebView(
          url: url,
          onPaymentResult: (_) {},
        ),
      ),
    );

    if (!context.mounted) return;

    context.read<MyAppointmentsCubit>().refresh();
  }
}
