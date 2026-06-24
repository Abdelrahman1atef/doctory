import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_state.dart';
import 'package:doctory/features/booking/domain/enums/appointment_type.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_doctor_card.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_section_header.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_type_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentTypeSection extends StatelessWidget {
  const AppointmentTypeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (prev, curr) => curr is BookingData,
      builder: (context, state) {
        if (state is! BookingData) return const SizedBox.shrink();
        final cubit = context.read<BookingCubit>();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingDoctorCard(doctor: cubit.doctor),
              const SizedBox(height: 24),
              BookingSectionHeader(
                title: 'appointment_type'.tr(),
                subtitle: 'choose_appointment_type'.tr(),
              ),
              const SizedBox(height: 20),
              BookingTypeCard(
                icon: Icons.person_outline_rounded,
                title: 'in_person'.tr(),
                subtitle: 'in_person_desc'.tr(),
                isSelected: state.appointmentType.value == 0,
                onTap: () => cubit.selectAppointmentType(
                  AppointmentType.fromValue(1),
                ),
              ),
              const SizedBox(height: 12),
              BookingTypeCard(
                icon: Icons.replay_outlined,
                title: 'follow_up'.tr(),
                subtitle: 'follow_up_desc'.tr(),
                isSelected: state.appointmentType.value == 1,
                onTap: () => cubit.selectAppointmentType(
                  AppointmentType.fromValue(3),
                ),
              ),
              // const SizedBox(height: 12),
              // BookingTypeCard(
              //   icon: Icons.videocam_outlined,
              //   title: 'online'.tr(),
              //   subtitle: 'online_desc'.tr(),
              //   isSelected: state.appointmentType.value == 2,
              //   onTap: () => cubit.selectAppointmentType(
              //     AppointmentType.fromValue(2),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
