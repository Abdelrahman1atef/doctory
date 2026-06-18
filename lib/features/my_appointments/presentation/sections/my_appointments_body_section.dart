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

class MyAppointmentsBodySection extends StatelessWidget {
  const MyAppointmentsBodySection({super.key});

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
          child: BlocBuilder<MyAppointmentsCubit, MyAppointmentsState>(
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
                return MyAppointmentsListSection(
                  appointments: state.appointments,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

}
