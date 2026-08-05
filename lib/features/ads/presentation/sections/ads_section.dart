import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/ads/data/model/public_ad_model.dart';
import 'package:doctory/features/ads/presentation/widgets/ads_carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdsSection extends StatelessWidget {
  final List<PublicAdModel> ads;

  const AdsSection({super.key, required this.ads});

  @override
  Widget build(BuildContext context) {
    if (ads.isEmpty) return const SizedBox.shrink();

    return AdsCarouselWidget(
      ads: ads,
      title: context.l10n('ads_title'),
      onAdTap: (ad) => _openClinic(context, ad),
    );
  }

  void _openClinic(BuildContext context, PublicAdModel ad) {
    final clinic = ClinicModel(
      id: ad.clinicId,
      name: ad.clinicName ?? '',
      description: ad.clinicName ?? '',
      isRegistered: true,
    );
    context.push(AppRoutes.clinicDetails, extra: clinic);
  }
}