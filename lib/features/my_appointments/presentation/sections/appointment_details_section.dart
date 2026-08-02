import 'package:doctory/core/common/widgets/error/app_error_widget.dart';
import 'package:doctory/core/common/widgets/layout/abher_payment_webview.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';
import 'package:doctory/features/my_appointments/cubit/my_appointments_cubit.dart';
import 'package:doctory/features/my_appointments/cubit/my_appointments_state.dart';
import 'package:doctory/features/my_appointments/presentation/widgets/appointment_detail_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppointmentDetailsSection extends StatefulWidget {
  final AppointmentResponseDto? appointment;
  final String? appointmentId;

  const AppointmentDetailsSection({
    super.key,
    this.appointment,
    this.appointmentId,
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
    _lastAppointment = widget.appointment;
    if (_lastAppointment == null && widget.appointmentId != null) {
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
    switch (apt.status) {
      case 0:
      case 4:
      case 6:
        return true;
      case 1:
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
    final url = apt.paymobRedirectUrl;
    return apt.status == 6 && url != null && url.isNotEmpty;
  }

  void _popOnce() {
    final now = DateTime.now();
    if (_lastBackPress != null &&
        now.difference(_lastBackPress!) < _backPressDebounce) {
      return;
    }
    _lastBackPress = now;
    context.pop();
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.stitchPrimaryContainer,
                    ),
                    onPressed: _popOnce,
                  ),
                  const Spacer(),
                  Text(
                    'appointment_details'.tr(),
                    style: AppStyles.s20Bold.withColor(
                      AppColors.stitchPrimaryContainer,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
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
            if (_canPay || _canCancel) _buildActionBar(context, apt),
          ],
        );
      },
    );
  }

  Widget _buildActionBar(
    BuildContext context,
    AppointmentResponseDto apt,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLowest,
        border: const Border(
          top: BorderSide(color: AppColors.stitchSurfaceLow),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_canPay) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openPaymentWebView(context, apt),
                icon: const Icon(Icons.payment),
                label: Text('pay_now'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.stitchPrimaryContainer,
                  foregroundColor: AppColors.stitchSurfaceLowest,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: AppStyles.s16Bold,
                ),
              ),
            ),
          ],
          if (_canPay && _canCancel) 12.ph,
          if (_canCancel) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _cancelling
                    ? null
                    : () => _confirmCancel(context, apt),
                icon: const Icon(Icons.cancel_outlined),
                label: Text('cancel_appointment'.tr()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(
                    color: _cancelling
                        ? AppColors.error.withValues(alpha: 0.4)
                        : AppColors.error,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openPaymentWebView(
    BuildContext context,
    AppointmentResponseDto apt,
  ) async {
    final url = apt.paymobRedirectUrl;
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
    final reason = await _showCancelReasonDialog(context);
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

  Future<String?> _showCancelReasonDialog(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('cancel_appointment'.tr()),
        content: TextField(
          controller: controller,
          maxLines: 3,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'cancel_reason_hint'.tr(),
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('no'.tr()),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (ctx, value, _) => TextButton(
              onPressed: value.text.trim().isEmpty
                  ? null
                  : () => Navigator.of(ctx).pop(value.text.trim()),
              child: Text('yes'.tr(), style:  TextStyle(color: AppColors.error)),
            ),
          ),
        ],
      ),
    );
  }
}
