import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_spacing.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/ads/data/model/public_ad_model.dart';
import 'package:doctory/features/ads/presentation/sections/ads_section.dart';
import 'package:doctory/features/home/presentation/sections/home_featured_section.dart';
import 'package:doctory/features/home/presentation/sections/home_header_section.dart';
import 'package:doctory/features/home/presentation/sections/home_search_section.dart';
import 'package:doctory/features/home/presentation/sections/home_specialties_section.dart';
import 'package:doctory/features/home/presentation/widgets/section_container_widget.dart';
import 'package:flutter/material.dart';

/// Scrollable body of the home screen. Pure layout — every value it renders
/// arrives as a parameter.
class HomeContentWidget extends StatelessWidget {
  final List<SpecialtyModel> specialties;
  final List<DoctorModel> recommendedDoctors;
  final List<ClinicModel> featuredClinics;
  final List<PublicAdModel> ads;

  const HomeContentWidget({
    super.key,
    this.specialties = const <SpecialtyModel>[],
    this.recommendedDoctors = const <DoctorModel>[],
    this.featuredClinics = const <ClinicModel>[],
    this.ads = const <PublicAdModel>[],
  });

  bool get _hasFeatured =>
      recommendedDoctors.isNotEmpty || featuredClinics.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        left: AppSpacing.s24,
        right: AppSpacing.s24,
        top: AppSpacing.s16,
        bottom: context.bottomPadding,
      ),
      child: Column(
        mainAxisAlignment: _hasFeatured
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          const HomeHeaderSection(),
          if (_hasFeatured) 250.ph else 100.ph,
          if (ads.isNotEmpty) ...[AdsSection(ads: ads), 24.ph],
          const HomeSearchSection(),
          24.ph,
          HomeSpecialtiesSection(specialties: specialties),
          if (_hasFeatured) ...[
            16.ph,
            SectionContainerWidget(
              child: HomeFeaturedSection(
                doctors: recommendedDoctors,
                clinics: featuredClinics,
              ),
            ),
          ],
          24.ph,
        ],
      ),
    );
  }
}
