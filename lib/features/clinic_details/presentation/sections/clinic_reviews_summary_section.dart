import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/patient_reviews/cubit/clinic_ratings_summary_cubit.dart';
import 'package:doctory/features/patient_reviews/cubit/clinic_ratings_summary_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClinicReviewsSummarySection extends StatelessWidget {
  final ClinicModel clinic;
  final VoidCallback onSeeAll;

  const ClinicReviewsSummarySection({
    super.key,
    required this.clinic,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.stitchSurfaceLow),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 28,
                      ),
                    ),
                    16.pw,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${clinic.rating.roundTo2numberString} / 5.0',
                          style: AppStyles.s18Bold.withColor(
                            AppColors.stitchPrimaryContainer,
                          ),
                        ),
                        4.ph,
                        Text(
                          LocaleKeys.based_on_reviews
                              .tr(args: [clinic.reviewsCount.toString()]),
                          style: AppStyles.s12Medium.withColor(
                            AppColors.stitchSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: Text(
                  'reviews'.tr(),
                  style: AppStyles.s14Bold.withColor(
                    AppColors.stitchPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const _ClinicTypeStats(),
        ],
      ),
    );
  }
}

class _ClinicTypeStats extends StatelessWidget {
  const _ClinicTypeStats();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicRatingsSummaryCubit, ClinicRatingsSummaryStates>(
      builder: (context, state) {
        if (state is ClinicRatingsSummaryLoading ||
            state is ClinicRatingsSummaryInitial) {
          return const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.stitchPrimaryContainer,
                ),
              ),
            ),
          );
        }

        if (state is ClinicRatingsSummaryError) return const SizedBox.shrink();

        if (state is ClinicRatingsSummaryLoaded) {
          return Column(
            children: [
              16.ph,
              const Divider(color: AppColors.stitchSurfaceLow),
              16.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _RatingStatWidget(
                    label: LocaleKeys.rate_clinic.tr(),
                    average: state.clinicAverage,
                    count: state.clinicCount,
                  ),
                  _RatingStatWidget(
                    label: LocaleKeys.reception.tr(),
                    average: state.receptionAverage,
                    count: state.receptionCount,
                  ),
                  _RatingStatWidget(
                    label: LocaleKeys.cleanliness.tr(),
                    average: state.cleanlinessAverage,
                    count: state.cleanlinessCount,
                  ),
                ],
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _RatingStatWidget extends StatelessWidget {
  final String label;
  final double average;
  final int count;

  const _RatingStatWidget({
    required this.label,
    required this.average,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppStyles.s10Medium.withColor(AppColors.stitchSecondary),
        ),
        4.ph,
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
            4.pw,
            Text(
              average.toStringAsFixed(1),
              style: AppStyles.s12Bold.withColor(
                AppColors.stitchPrimaryContainer,
              ),
            ),
          ],
        ),
        4.ph,
        Text(
          '$count',
          style: AppStyles.s10Medium.withColor(AppColors.stitchSecondary),
        ),
      ],
    );
  }
}