import 'package:doctory/core/common/widgets/error/app_error_widget.dart';
import 'package:doctory/core/common/widgets/layout/abher_payment_webview.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';
import 'package:doctory/features/booking/domain/enums/appointment_status.dart';
import 'package:doctory/features/my_appointments/cubit/my_appointments_cubit.dart';
import 'package:doctory/features/my_appointments/cubit/my_appointments_state.dart';
import 'package:doctory/features/my_appointments/presentation/sections/appointment_details_appbar_section.dart';
import 'package:doctory/features/my_appointments/presentation/widgets/appointment_action_bar_widget.dart';
import 'package:doctory/features/my_appointments/presentation/widgets/appointment_detail_card.dart';
import 'package:doctory/features/my_appointments/presentation/widgets/cancel_appointment_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppointmentDetailsSection extends StatefulWidget {
  final String? appointmentId;
  final String? paymentUrl;

  const AppointmentDetailsSection({
    super.key,
    this.appointmentId,
    this.paymentUrl,
  });

  @override
  State<AppointmentDetailsSection> createState() =>
      _AppointmentDetailsSectionState();
}

class _AppointmentDetailsSectionState extends State<AppointmentDetailsSection> {
  static const Duration _paidCancelWindow = Duration(hours: 2);
  static const Duration _backPressDebounce = Duration(milliseconds: 400);

  AppointmentResponseDto? _lastAppointment;
  bool _cancelling = false;
  DateTime? _lastBackPress;

  @override
  void initState() {
    super.initState();
    if (widget.appointmentId != null) {
      context
          .read<MyAppointmentsCubit>()
          .loadAppointmentById(widget.appointmentId!);
    }
  }

  AppointmentResponseDto? get _appointment {
    final state = context.read<MyAppointmentsCubit>().state;
    if (state is MyAppointmentsDetailsLoaded) return state.appointment;
    return _lastAppointment;
  }

  bool get _canCancel {
    final apt = _appointment;
    if (apt == null) return false;
    switch (apt.appointmentStatus) {
      case AppointmentStatus.pending:
      case AppointmentStatus.reserved:
      case AppointmentStatus.accepted:
        return true;
      case AppointmentStatus.confirmed:
        final paidAt = apt.paidAt;
        if (paidAt == null) return true;
        return DateTime.now().difference(paidAt) < _paidCancelWindow;
      default:
        return false;
    }
  }

  bool get _canPay {
    final apt = _appointment;
    if (apt == null) return false;
    final url = apt.paymobRedirectUrl ?? widget.paymentUrl;
    return apt.appointmentStatus == AppointmentStatus.accepted &&
        url != null &&
        url.isNotEmpty;
  }

  void _popOnce() {
    final now = DateTime.now();
    if (_lastBackPress != null &&
        now.difference(_lastBackPress!) < _backPressDebounce) {
      return;
    }
    _lastBackPress = now;
    if (context.canPop()) {
      try {
        context.pop();
        return;
      } catch (_) {}
    }
    context.go(AppRoutes.myAppointments);
  }

  Future<void> _refresh() async {
    final apt = _appointment;
    if (apt == null) return;
    await context
        .read<MyAppointmentsCubit>()
        .loadAppointmentById(apt.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyAppointmentsCubit, MyAppointmentsState>(
      listener: (context, state) {
        if (state is MyAppointmentsDetailsLoaded) {
          _lastAppointment = state.appointment;
        }
        if (state is MyAppointmentsError && _lastAppointment != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final apt = _appointment;

        if (apt == null && state is MyAppointmentsDetailsLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.stitchPrimaryContainer,
            ),
          );
        }

        if (apt == null && state is MyAppointmentsError) {
          return AppErrorWidget(
            message: state.message,
            icon: Icons.event_busy_rounded,
            onRetry: widget.appointmentId == null
                ? null
                : () => context
                    .read<MyAppointmentsCubit>()
                    .loadAppointmentById(widget.appointmentId!),
          );
        }

        if (apt == null) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            AppointmentDetailsAppBarSection(onBack: _popOnce),
            16.ph,
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                color: AppColors.stitchPrimaryContainer,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      AppointmentDetailCard(appointment: apt),
                      40.ph,
                    ],
                  ),
                ),
              ),
            ),
            if (_canPay || _canCancel)
              AppointmentActionBarWidget(
                onPayTap: _canPay
                    ? () => _openPaymentWebView(context, apt)
                    : null,
                onCancelTap: _canCancel
                    ? () => _confirmCancel(context, apt)
                    : null,
                isCancelling: _cancelling,
              ),
          ],
        );
      },
    );
  }

  Future<void> _openPaymentWebView(
    BuildContext context,
    AppointmentResponseDto apt,
  ) async {
    final url = apt.paymobRedirectUrl ?? widget.paymentUrl;
    if (url == null || url.isEmpty) return;

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

    if (paymentSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('payment_successful'.tr()),
          backgroundColor: AppColors.success,
        ),
      );
    }
    context.pop();
  }

  Future<void> _confirmCancel(
    BuildContext context,
    AppointmentResponseDto apt,
  ) async {
    final reason = await showCancelAppointmentDialog(context);
    if (reason == null || !context.mounted) return;

    setState(() => _cancelling = true);

    final cubit = context.read<MyAppointmentsCubit>();
    final success = await cubit.cancelAppointment(
      id: apt.id,
      cancellationReason: reason,
    );

    if (!context.mounted) return;
    setState(() => _cancelling = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('appointment_cancelled'.tr()),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }
}