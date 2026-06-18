import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/patient_reviews/cubit/patient_reviews_cubit.dart';
import 'package:doctory/features/patient_reviews/cubit/patient_reviews_states.dart';
import 'package:doctory/features/patient_reviews/presentation/widgets/review_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PatientReviewsView extends StatelessWidget {
  final dynamic entity; // Can be ClinicModel or DoctorModel

  const PatientReviewsView({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    String entityId = '';
    double rating = 0.0;
    int reviewsCount = 0;

    if (entity is ClinicModel) {
      entityId = (entity as ClinicModel).id;
      rating = (entity as ClinicModel).rating;
      reviewsCount = (entity as ClinicModel).reviewsCount;
    } else if (entity is DoctorModel) {
      entityId = (entity as DoctorModel).id;
      rating = (entity as DoctorModel).rating;
      reviewsCount = (entity as DoctorModel).reviewsCount;
    }

    return BlocProvider(
      create: (context) => PatientReviewsCubit()..loadReviews(entityId),
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
            'patient_reviews'.tr(),
            style: AppStyles.s18Bold.withColor(
              AppColors.stitchPrimaryContainer,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Overall Rating Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.stitchSurfaceLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    rating.toString(),
                    style: AppStyles.s32Bold.withColor(
                      AppColors.stitchPrimaryContainer,
                    ),
                  ),
                  16.pw,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star_rounded,
                            color: index < rating.floor()
                                ? Colors.amber
                                : AppColors.stitchSurfaceLow,
                            size: 24,
                          ),
                        ),
                      ),
                      4.ph,
                      Text(
                        'Based on $reviewsCount reviews',
                        style: AppStyles.s14Medium.withColor(
                          AppColors.stitchSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Reviews List
            Expanded(
              child: BlocBuilder<PatientReviewsCubit, PatientReviewsStates>(
                builder: (context, state) {
                  if (state is PatientReviewsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.stitchPrimaryContainer,
                      ),
                    );
                  }
                  if (state is PatientReviewsLoaded) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.reviews.length,
                      itemBuilder: (context, index) {
                        return ReviewCardWidget(review: state.reviews[index]);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            // Write Review Button
            Container(
              padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.paddingOf(context).bottom),
              decoration: BoxDecoration(
                color: AppColors.stitchSurfaceLowest,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to write review or show bottom sheet
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.stitchPrimaryContainer,
                    side: const BorderSide(
                      color: AppColors.stitchPrimaryContainer,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text('write_review'.tr(), style: AppStyles.s16Bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
