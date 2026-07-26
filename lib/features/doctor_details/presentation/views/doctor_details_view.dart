import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/doctor_details/cubit/doctor_details_cubit.dart';
import 'package:doctory/features/doctor_details/cubit/doctor_details_states.dart';
import 'package:doctory/features/doctor_details/presentation/sections/doctor_about_section.dart';
import 'package:doctory/features/doctor_details/presentation/sections/doctor_availability_section.dart';
import 'package:doctory/features/doctor_details/presentation/sections/doctor_profile_section.dart';
import 'package:doctory/features/doctor_details/presentation/sections/doctor_reviews_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

class DoctorDetailsView extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailsView({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DoctorDetailsCubit, DoctorDetailsStates>(
          builder: (context, state) {
            if (state is DoctorDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final currentDoctor = state is DoctorDetailsLoaded
                ? state.doctor
                : doctor;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AppBarSection(),
                  24.ph,
                  DoctorProfileSection(doctor: currentDoctor),
                  32.ph,
                  DoctorAboutSection(doctor: currentDoctor),
                  32.ph,
                  DoctorAvailabilitySection(doctor: currentDoctor),
                  if (currentDoctor.recentRatings != null &&
                      currentDoctor.recentRatings!.isNotEmpty) ...[
                    32.ph,
                    DoctorReviewsSection(ratings: currentDoctor.recentRatings!),
                  ],
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

class _AppBarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
            'doctor_details'.tr(),
            style: AppStyles.s18Bold.withColor(AppColors.stitchPrimaryContainer),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
