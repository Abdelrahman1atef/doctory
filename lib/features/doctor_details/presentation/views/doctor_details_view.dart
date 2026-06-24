import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/doctor_details/cubit/doctor_details_cubit.dart';
import 'package:doctory/features/doctor_details/cubit/doctor_details_states.dart';
import 'package:doctory/features/doctor_details/presentation/sections/doctor_about_section.dart';
import 'package:doctory/features/doctor_details/presentation/sections/doctor_availability_section.dart';
import 'package:doctory/features/doctor_details/presentation/sections/doctor_profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:doctory/core/theme/app_typography.dart';

class DoctorDetailsView extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailsView({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorDetailsCubit()..loadDoctorDetails(doctor.id),
      child: Scaffold(
        backgroundColor: AppColors.stitchSurface,
        appBar: AppBar(
          backgroundColor: AppColors.stitchSurface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.stitchPrimaryContainer,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'doctor_details'.tr(),
            style: AppStyles.s18Bold.withColor(
              AppColors.stitchPrimaryContainer,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<DoctorDetailsCubit, DoctorDetailsStates>(
          builder: (context, state) {
            if (state is DoctorDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.stitchPrimaryContainer,
                ),
              );
            }

            final currentDoctor = state is DoctorDetailsLoaded
                ? state.doctor
                : doctor;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoctorProfileSection(doctor: currentDoctor),
                  32.ph,
                  DoctorAboutSection(doctor: currentDoctor),
                  32.ph,
                  DoctorAvailabilitySection(doctor: currentDoctor),
                  40.ph,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
