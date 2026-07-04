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
  final AppointmentResponseDto appointment;

  const AppointmentDetailsSection({super.key, required this.appointment});

  @override
  State<AppointmentDetailsSection> createState() =>
      _AppointmentDetailsSectionState();
}

class _AppointmentDetailsSectionState extends State<AppointmentDetailsSection> {
  bool _paymentHandled = false;

  @override
  Widget build(BuildContext context) {
    final canCancel =
        widget.appointment.status != 3 &&
        widget.appointment.status != 2 &&
        widget.appointment.status != 6 &&
        widget.appointment.status != 7;
    final isPending = widget.appointment.status == 0;

    return BlocConsumer<MyAppointmentsCubit, MyAppointmentsState>(
      listener: (context, state) {
        if (state is MyAppointmentsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
        if (state is MyAppointmentsLoaded) {
          final updated = state.appointments.firstWhere(
            (a) => a.id == widget.appointment.id,
            orElse: () => widget.appointment,
          );
          if (updated.status == 2 && widget.appointment.status != 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('appointment_cancelled'.tr()),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop();
          }
          if (state.paymentUrl != null && !_paymentHandled) {
            _paymentHandled = true;
            _openPaymentWebView(context, state.paymentUrl!);
          }
          if (updated.status == 1 &&
              widget.appointment.status == 0 &&
              _paymentHandled) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('payment_successful'.tr()),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop();
          }
        }
      },
      builder: (context, state) {
        final isProcessing =
            state is MyAppointmentsLoaded && state.isProcessingPayment;

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
                    onPressed: () => context.pop(),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    AppointmentDetailCard(appointment: widget.appointment),
                    if (isPending) ...[
                      32.ph,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: isProcessing
                              ? null
                              : () {
                                  _paymentHandled = false;
                                  context
                                      .read<MyAppointmentsCubit>()
                                      .initiatePayment(widget.appointment);
                                },
                          icon: isProcessing
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.stitchSurfaceLowest,
                                  ),
                                )
                              : const Icon(Icons.payment),
                          label: Text(
                            isProcessing ? 'processing'.tr() : 'pay_now'.tr(),
                          ),
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
                    if (canCancel) ...[
                      16.ph,
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: isProcessing
                              ? null
                              : () => _confirmCancel(context),
                          icon: const Icon(Icons.cancel_outlined),
                          label: Text('cancel_appointment'.tr()),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: BorderSide(color: AppColors.error),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                    40.ph,
                  ],
                ),
              ),
            ),
          ],
        );
      },
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

    context.read<MyAppointmentsCubit>().onPaymentResult(
      paymentSuccess,
      widget.appointment,
    );
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('cancel_appointment'.tr()),
        content: Text('cancel_confirm_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('no'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<MyAppointmentsCubit>().cancelAppointment(
                widget.appointment.id,
              );
            },
            child: Text('yes'.tr(), style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
