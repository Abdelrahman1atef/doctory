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

class AppointmentDetailsSection extends StatelessWidget {
  final AppointmentResponseDto appointment;

  const AppointmentDetailsSection({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final canCancel = appointment.status != 'completed' && appointment.status != 'cancelled';

    return BlocConsumer<MyAppointmentsCubit, MyAppointmentsState>(
      listener: (context, state) {
        if (state is MyAppointmentsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
        if (state is MyAppointmentsLoaded) {
          final updated = state.appointments.firstWhere(
            (a) => a.id == appointment.id,
            orElse: () => appointment,
          );
          if (updated.status == 'cancelled' && appointment.status != 'cancelled') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('appointment_cancelled'.tr()),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop();
          }
        }
      },
      builder: (context, state) {
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
                  Text('appointment_details'.tr(),
                    style: AppStyles.s20Bold.withColor(AppColors.stitchPrimaryContainer)),
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
                    AppointmentDetailCard(appointment: appointment),
                    if (canCancel) ...[
                      32.ph,
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _confirmCancel(context),
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
              context.read<MyAppointmentsCubit>().cancelAppointment(appointment.id);
            },
            child: Text('yes'.tr(), style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
