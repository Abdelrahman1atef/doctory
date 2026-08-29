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
import 'package:doctory/features/patient_reviews/cubit/clinic_ratings_summary_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClinicDetailsView extends StatelessWidget {
  const ClinicDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stitchSurface,
      body: BlocBuilder<ClinicDetailsCubit, ClinicDetailsStates>(
        builder: (context, state) {
          if (state is ClinicDetailsInitial || state is ClinicDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.stitchPrimaryContainer,
              ),
            );
          }

          if (state is ClinicDetailsLoaded) {
            final currentClinic = state.clinic;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ClinicDetailsCubit>().refresh();
                context
                    .read<ClinicRatingsSummaryCubit>()
                    .loadSummary(currentClinic.id);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ClinicImageHeader(clinic: currentClinic),
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
              ),
            );
          }

          if (state is ClinicDetailsError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: AppColors.error),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ClinicImageHeader extends StatelessWidget {
  final ClinicModel clinic;

  const _ClinicImageHeader({required this.clinic});

  @override
  Widget build(BuildContext context) {
    final imageUrl = clinic.logo?.toImageUrl ??
        clinic.imageUrl?.toImageUrl ??
        '';
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        SizedBox(
          height: 400,
          width: double.infinity,
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildPlaceholder(),
                )
              : _buildPlaceholder(),
        ),
        PositionedDirectional(
          top: topPadding + 8,
          start: 16,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.stitchPrimaryContainer,
            ),
            onPressed: () => context.pop(),
            style: IconButton.styleFrom(
              backgroundColor:
                  AppColors.stitchSurfaceLowest.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.stitchSurfaceLow,
      child: const Center(
        child: Icon(
          Icons.local_hospital,
          size: 64,
          color: AppColors.stitchSecondary,
        ),
      ),
    );
  }
}
