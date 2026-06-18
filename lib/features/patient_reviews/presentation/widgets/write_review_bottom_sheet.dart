import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/core/common/widgets/inputs/stitch_text_field.dart';
import 'package:doctory/features/patient_reviews/cubit/patient_reviews_cubit.dart';
import 'package:doctory/features/patient_reviews/cubit/patient_reviews_states.dart';
import 'package:doctory/features/patient_reviews/presentation/widgets/star_rating_input_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WriteReviewBottomSheet extends StatefulWidget {
  final String entityId;

  const WriteReviewBottomSheet({super.key, required this.entityId});

  @override
  State<WriteReviewBottomSheet> createState() => _WriteReviewBottomSheetState();
}

class _WriteReviewBottomSheetState extends State<WriteReviewBottomSheet> {
  double _cleanlinessRating = 0;
  double _behaviorRating = 0;
  double _receptionRating = 0;
  final TextEditingController _commentController = TextEditingController();

  bool get _isValid => _cleanlinessRating > 0 && _behaviorRating > 0 && _receptionRating > 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientReviewsCubit, PatientReviewsStates>(
      listener: (context, state) {
        if (state is PatientReviewSubmitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.submit_review_success.tr()),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        } else if (state is PatientReviewsError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
        }
      },
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          ),
          decoration: const BoxDecoration(
            color: AppColors.stitchSurfaceLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.stitchSurfaceLow,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                24.ph,
                Text(
                  LocaleKeys.write_review.tr(),
                  style: AppStyles.s20Bold.withColor(AppColors.stitchPrimaryContainer),
                ),
                24.ph,
                _buildRatingRow(
                  LocaleKeys.cleanliness.tr(),
                  _cleanlinessRating,
                  (val) => setState(() => _cleanlinessRating = val),
                ),
                16.ph,
                _buildRatingRow(
                  LocaleKeys.doctor_behavior.tr(),
                  _behaviorRating,
                  (val) => setState(() => _behaviorRating = val),
                ),
                16.ph,
                _buildRatingRow(
                  LocaleKeys.reception.tr(),
                  _receptionRating,
                  (val) => setState(() => _receptionRating = val),
                ),
                24.ph,
                Text(
                  'comment'.tr(), // Using existing 'comment' key
                  style: AppStyles.s14Bold.withColor(AppColors.stitchPrimaryContainer),
                ),
                8.ph,
                StitchTextField(
                  controller: _commentController,
                  hintText: LocaleKeys.enter_rating_comment_hint.tr(),
                  maxLines: 4,
                ),
                32.ph,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isValid && state is! PatientReviewSubmitting ? _submitReview : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.stitchPrimaryContainer,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      disabledBackgroundColor: AppColors.stitchSurfaceLow,
                    ),
                    child: state is PatientReviewSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            LocaleKeys.submit_review.tr(),
                            style: AppStyles.s16Bold.withColor(Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingRow(String label, double rating, ValueChanged<double> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppStyles.s16Medium.withColor(AppColors.stitchSecondary)),
        StarRatingInputWidget(rating: rating, onRatingChanged: onChanged, size: 28),
      ],
    );
  }

  void _submitReview() {
    final overallRating = (_cleanlinessRating + _behaviorRating + _receptionRating) / 3;
    context.read<PatientReviewsCubit>().submitReview(
      entityId: widget.entityId,
      rating: overallRating,
      cleanlinessRating: _cleanlinessRating,
      behaviorRating: _behaviorRating,
      receptionRating: _receptionRating,
      comment: _commentController.text,
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
