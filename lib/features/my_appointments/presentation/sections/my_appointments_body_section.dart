import 'package:doctory/core/common/widgets/layout/abher_payment_webview.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/my_appointments/cubit/my_appointments_cubit.dart';
import 'package:doctory/features/my_appointments/cubit/my_appointments_state.dart';
import 'package:doctory/features/my_appointments/presentation/sections/my_appointments_list_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyAppointmentsBodySection extends StatefulWidget {
  const MyAppointmentsBodySection({super.key});

  @override
  State<MyAppointmentsBodySection> createState() => _MyAppointmentsBodySectionState();
}

class _MyAppointmentsBodySectionState extends State<MyAppointmentsBodySection> {
  bool _paymentHandled = false;

  @override
  Widget build(BuildContext context) {
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
              Text('my_appointments'.tr(),
                style: AppStyles.s20Bold.withColor(AppColors.stitchPrimaryContainer)),
              const Spacer(),
              const SizedBox(width: 48),
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
              if (state is MyAppointmentsLoaded && state.paymentUrl != null && !_paymentHandled) {
                _paymentHandled = true;
                _openPaymentWebView(context, state.paymentUrl!);
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
          onPayTap: (appointment) {
            _paymentHandled = false;
            context.read<MyAppointmentsCubit>().initiatePayment(appointment);
          },
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

  Future<void> _openPaymentWebView(BuildContext context, String url) async {
    var paymentSuccess = false;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AbherPaymentWebView(
          url: url,
          onPaymentResult: (success) {
            paymentSuccess = success;
          },
        ),
      ),
    );

    if (!context.mounted) return;

    final cubit = context.read<MyAppointmentsCubit>();
    final currentState = cubit.state;
    if (currentState is! MyAppointmentsLoaded) return;

    if (paymentSuccess) {
      final appointment = currentState.appointments.firstWhere(
        (a) => a.status == 0,
        orElse: () => currentState.appointments.first,
      );
      cubit.onPaymentResult(true, appointment);
      cubit.loadByStatus(currentState.statusFilter ?? 0);
    } else {
      cubit.onPaymentResult(false, currentState.appointments.first);
    }
  }
}