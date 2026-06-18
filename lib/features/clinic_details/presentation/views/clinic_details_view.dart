import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/clinic_details/cubit/clinic_details_cubit.dart';
import 'package:doctory/features/clinic_details/cubit/clinic_details_states.dart';
import 'package:doctory/features/clinic_details/presentation/sections/clinic_doctors_section.dart';
import 'package:doctory/features/clinic_details/presentation/sections/clinic_header_section.dart';
import 'package:doctory/features/clinic_details/presentation/sections/clinic_info_section.dart';
import 'package:doctory/features/clinic_details/presentation/sections/clinic_reviews_summary_section.dart';
import 'package:doctory/features/clinic_details/presentation/widgets/clinic_photo_carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClinicDetailsView extends StatelessWidget {
  final ClinicModel clinic;

  const ClinicDetailsView({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClinicDetailsCubit()..loadClinicDetails(clinic.id),
      child: Scaffold(
        backgroundColor: AppColors.stitchSurface,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.stitchPrimaryContainer,
            ),
            onPressed: () => context.pop(),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.stitchSurfaceLowest.withValues(
                alpha: 0.8,
              ),
            ),
          ),
        ),
        body: BlocBuilder<ClinicDetailsCubit, ClinicDetailsStates>(
          builder: (context, state) {
            if (state is ClinicDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.stitchPrimaryContainer,
                ),
              );
            }

            final currentClinic = state is ClinicDetailsLoaded
                ? state.clinic
                : clinic;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClinicPhotoCarouselWidget(
                    photos:
                        currentClinic.photos ?? [currentClinic.imageUrl ?? ''],
                  ),
                  ClinicHeaderSection(clinic: currentClinic),
                  16.ph,
                  ClinicInfoSection(clinic: currentClinic),
                  24.ph,
                  if (currentClinic.doctors != null) ...[
                    ClinicDoctorsSection(doctors: currentClinic.doctors!),
                    24.ph,
                  ],
                  ClinicReviewsSummarySection(
                    clinic: currentClinic,
                    onSeeAll: () {
                      context.push(
                        AppRoutes.patientReviews,
                        extra: currentClinic,
                      );
                    },
                  ),
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
