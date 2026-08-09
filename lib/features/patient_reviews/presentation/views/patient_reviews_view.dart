import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/patient_reviews/cubit/patient_reviews_cubit.dart';
import 'package:doctory/features/patient_reviews/cubit/patient_reviews_states.dart';
import 'package:doctory/features/patient_reviews/data/model/rating_target.dart';
import 'package:doctory/features/patient_reviews/presentation/widgets/review_card_widget.dart';
import 'package:doctory/features/patient_reviews/presentation/widgets/write_review_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PatientReviewsView extends StatelessWidget {
  final dynamic entity; // Can be ClinicModel or DoctorModel
  final RatingTarget target;

  const PatientReviewsView({super.key, required this.entity, required this.target});

  @override
  Widget build(BuildContext context) {
    double rating = 0.0;
    int reviewsCount = 0;

    if (entity is ClinicModel) {
      rating = (entity as ClinicModel).rating;
      reviewsCount = (entity as ClinicModel).reviewsCount;
    } else if (entity is DoctorModel) {
      rating = (entity as DoctorModel).rating;
      reviewsCount = (entity as DoctorModel).reviewsCount;
    }

    return Scaffold(
      backgroundColor: AppColors.stitchSurface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context),
            _OverallRatingCard(rating: rating, reviewsCount: reviewsCount),
            Expanded(child: _ReviewsListSection(target: target)),
            _WriteReviewButton(target: target, entity: entity),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.stitchPrimaryContainer,
            ),
            onPressed: () => context.pop(),
          ),
          Text(
            'patient_reviews'.tr(),
            style: AppStyles.s18Bold.withColor(
              AppColors.stitchPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverallRatingCard extends StatelessWidget {
  final double rating;
  final int reviewsCount;

  const _OverallRatingCard({required this.rating, required this.reviewsCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
    );
  }
}

class _ReviewsListSection extends StatelessWidget {
  final RatingTarget target;

  const _ReviewsListSection({required this.target});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientReviewsCubit, PatientReviewsStates>(
      builder: (context, state) {
        if (state is PatientReviewsLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.stitchPrimaryContainer,
            ),
          );
        }
        if (state is PatientReviewsError) {
          return RefreshIndicator(
            onRefresh: () => context
                .read<PatientReviewsCubit>()
                .loadReviews(target),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 200,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: AppStyles.s14Medium.withColor(
                          AppColors.stitchSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        if (state is PatientReviewsLoaded) {
          return RefreshIndicator(
            onRefresh: () =>
                context.read<PatientReviewsCubit>().refreshReviews(target),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.reviews.length,
              itemBuilder: (context, index) {
                return ReviewCardWidget(review: state.reviews[index]);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _WriteReviewButton extends StatelessWidget {
  final RatingTarget target;
  final dynamic entity; // Can be ClinicModel or DoctorModel

  const _WriteReviewButton({required this.target, required this.entity});

  @override
  Widget build(BuildContext context) {
    final clinicDoctors =
        entity is ClinicModel ? (entity as ClinicModel).doctors ?? const [] : const <DoctorModel>[];
    final linkedClinicId = entity is DoctorModel ? (entity as DoctorModel).clinicId : null;
    return Container(
      padding: const EdgeInsets.all(16).copyWith(
        bottom: MediaQuery.paddingOf(context).bottom,
      ),
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
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => BlocProvider.value(
                value: context.read<PatientReviewsCubit>(),
                child: WriteReviewBottomSheet(
                  target: target,
                  clinicDoctors: clinicDoctors,
                  linkedClinicId: linkedClinicId,
                ),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.stitchPrimaryContainer,
            side: const BorderSide(color: AppColors.stitchPrimaryContainer),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text('write_review'.tr(), style: AppStyles.s16Bold),
        ),
      ),
    );
  }
}