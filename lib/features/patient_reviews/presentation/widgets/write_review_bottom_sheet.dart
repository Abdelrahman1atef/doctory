import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/common/widgets/inputs/stitch_text_field.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/patient_reviews/cubit/patient_reviews_cubit.dart';
import 'package:doctory/features/patient_reviews/cubit/patient_reviews_states.dart';
import 'package:doctory/features/patient_reviews/data/model/rating_target.dart';
import 'package:doctory/features/patient_reviews/data/model/rating_type.dart';
import 'package:doctory/features/patient_reviews/presentation/widgets/star_rating_input_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Rating sheet with one section per `RatingType` (doctor / clinic /
/// place cleanliness). Each section submits its own `POST /ratings` row.
///
/// - Clinic page → all 3 sections; the doctor section requires picking a
///   doctor from the clinic's doctors list.
/// - Doctor page → doctor section always; clinic + cleanliness sections
///   appear when the doctor belongs to a clinic ([linkedClinicId]).
class WriteReviewBottomSheet extends StatefulWidget {
  final RatingTarget target;

  /// Doctors of the clinic being rated (used to pick a doctor for type 1).
  final List<DoctorModel> clinicDoctors;

  /// Clinic the viewed doctor belongs to (enables type 2 + 3 on doctor pages).
  final String? linkedClinicId;

  const WriteReviewBottomSheet({
    super.key,
    required this.target,
    this.clinicDoctors = const [],
    this.linkedClinicId,
  });

  @override
  State<WriteReviewBottomSheet> createState() => _WriteReviewBottomSheetState();
}

class _WriteReviewBottomSheetState extends State<WriteReviewBottomSheet> {
  final Map<RatingType, int> _values = {};
  final Map<RatingType, TextEditingController> _comments = {};
  late final Set<RatingType> _locked;
  String? _selectedDoctorId;
  bool _busy = false;

  List<RatingType> get _sections {
    return switch (widget.target.entityType) {
      RatingEntityType.doctor => [
        RatingType.doctor,
        if (widget.linkedClinicId != null) ...[
          RatingType.clinic,
          RatingType.placeCleanliness,
        ],
      ],
      RatingEntityType.clinic => [
        if (widget.clinicDoctors.isNotEmpty) RatingType.doctor,
        RatingType.clinic,
        RatingType.placeCleanliness,
      ],
    };
  }

  bool get _hasPending => _sections.any((s) {
    if (_locked.contains(s) || (_values[s] ?? 0) <= 0) return false;
    if (s == RatingType.doctor &&
        widget.target.entityType == RatingEntityType.clinic) {
      return _selectedDoctorId != null;
    }
    return true;
  });

  @override
  void initState() {
    super.initState();
    final state = context.read<PatientReviewsCubit>().state;
    _locked = state is PatientReviewsLoaded ? state.alreadyRatedTypes : {};
    for (final section in _sections) {
      _comments[section] = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
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
              style: AppStyles.s20Bold.withColor(
                AppColors.stitchPrimaryContainer,
              ),
            ),
            24.ph,
            ..._sections.map(_buildSection),
            32.ph,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: !_hasPending ? null : _submitAll,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.stitchPrimaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  disabledBackgroundColor: AppColors.stitchSurfaceLow,
                ),
                child: Text(
                  LocaleKeys.submit_review.tr(),
                  style: AppStyles.s16Bold.withColor(Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(RatingType section) {
    final locked = _locked.contains(section);
    final value = _values[section] ?? 0;
    final isDoctorOnClinic =
        section == RatingType.doctor &&
        widget.target.entityType == RatingEntityType.clinic;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _sectionLabel(section),
                style: AppStyles.s16Medium.withColor(
                  AppColors.stitchSecondary,
                ),
              ),
              StarRatingInputWidget(
                rating: value.toDouble(),
                onRatingChanged: locked
                    ? (_) {}
                    : (val) => setState(() => _values[section] = val.toInt()),
                size: 28,
              ),
            ],
          ),
          if (isDoctorOnClinic && !locked) ...[
            12.ph,
            _buildDoctorPicker(),
          ],
          if (locked) ...[
            8.ph,
            Text(
              LocaleKeys.already_rated.tr(),
              style: AppStyles.s12Medium.withColor(AppColors.errorColor),
            ),
          ] else ...[
            12.ph,
            StitchTextField(
              controller: _comments[section],
              hintText: LocaleKeys.enter_rating_comment_hint.tr(),
              maxLines: 3,
              maxLength: 1000,
              isRequired: false,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDoctorPicker() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedDoctorId,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: LocaleKeys.select_doctor.tr(),
        labelStyle: AppStyles.s14Medium.withColor(AppColors.stitchSecondary),
        filled: true,
        fillColor: AppColors.stitchSurfaceLow.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: widget.clinicDoctors
          .map(
            (d) => DropdownMenuItem(
              value: d.id,
              child: Text(
                d.displayName,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.s14Medium,
              ),
            ),
          )
          .toList(),
      onChanged: _busy
          ? null
          : (id) => setState(() => _selectedDoctorId = id),
    );
  }

  String _sectionLabel(RatingType section) {
    return switch (section) {
      RatingType.doctor => LocaleKeys.rate_doctor.tr(),
      RatingType.clinic => LocaleKeys.rate_clinic.tr(),
      RatingType.placeCleanliness => LocaleKeys.place_cleanliness.tr(),
    };
  }

  Future<void> _submitAll() async {
    if (_busy) return;
    final cubit = context.read<PatientReviewsCubit>();
    _busy = true;

    var allSuccess = true;
    var anyAlreadyRated = false;
    var anySubmitted = false;
    String? errorMessage;

    for (final section in _sections) {
      if (_locked.contains(section) || (_values[section] ?? 0) <= 0) continue;
      if (section == RatingType.doctor &&
          widget.target.entityType == RatingEntityType.clinic &&
          _selectedDoctorId == null) {
        continue;
      }

      final doctorId = section == RatingType.doctor
          ? (widget.target.doctorId ?? _selectedDoctorId)
          : null;
      final clinicId =
          section == RatingType.clinic ||
              section == RatingType.placeCleanliness
          ? (widget.target.clinicId ?? widget.linkedClinicId)
          : null;

      final outcome = await cubit.submitSection(
        type: section,
        doctorId: doctorId,
        clinicId: clinicId,
        value: _values[section]!,
        review: _comments[section]!.text.trim().isEmpty
            ? null
            : _comments[section]!.text.trim(),
      );

      if (!mounted) return;

      switch (outcome.result) {
        case RatingSubmitResult.success:
          setState(() => _locked.add(section));
          anySubmitted = true;
        case RatingSubmitResult.alreadyRated:
          setState(() => _locked.add(section));
          anyAlreadyRated = true;
        case RatingSubmitResult.failed:
          allSuccess = false;
          errorMessage = outcome.message;
      }
    }

    if (!mounted) return;
    _busy = false;

    // Keep the list up to date without a visible loading state.
    if (anySubmitted) {
      await cubit.refreshReviews(widget.target);
      if (!mounted) return;
    }

    if (allSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.submit_review_success.tr()),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    } else if (!anyAlreadyRated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? LocaleKeys.submit_review.tr()),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.already_rated.tr()),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _comments.values) {
      controller.dispose();
    }
    super.dispose();
  }
}