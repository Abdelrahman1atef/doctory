import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/ads/data/model/public_ad_model.dart';
import 'package:doctory/features/ads/presentation/widgets/ads_banner_background_widget.dart';
import 'package:flutter/material.dart';

class AdsBadgeWidget extends StatelessWidget {
  final PublicAdModel ad;
  final VoidCallback? onTap;

  const AdsBadgeWidget({super.key, required this.ad, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.stitchPrimary,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AdsBannerBackgroundWidget(
              imageUrl: ad.imageUrl,
              clinicName: ad.clinicName ?? '',
            ),
            const _ScrimGradientOverlayWidget(),
            // const Positioned.fill(
            //   child: Align(
            //     alignment: AlignmentDirectional.topEnd,
            //     child: Padding(
            //       padding: EdgeInsets.all(12),
            //       child: AdsActiveTagWidget(),
            //     ),
            //   ),
            // ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 14,
              child: _BannerInfoWidget(ad: ad),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScrimGradientOverlayWidget extends StatelessWidget {
  const _ScrimGradientOverlayWidget();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.transparent,
            AppColors.black.withValues(alpha: 0.55),
          ],
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _BannerInfoWidget extends StatelessWidget {
  final PublicAdModel ad;

  const _BannerInfoWidget({required this.ad});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          ad.clinicName ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppStyles.s16Bold.copyWith(color: AppColors.white),
        ),
        // if (ad.packageNameAr != null && ad.packageNameAr!.isNotEmpty) ...[
        //   const SizedBox(height: 2),
        //   Text(
        //     ad.packageNameAr!,
        //     maxLines: 1,
        //     overflow: TextOverflow.ellipsis,
        //     style: AppStyles.s12Medium.copyWith(
        //       color: AppColors.white.withValues(alpha: 0.85),
        //     ),
        //   ),
        // ],
        // const SizedBox(height: 2),
        // Text(
        //   '${ad.startDate.formateDateOnly} → ${ad.endDate.formateDateOnly}',
        //   maxLines: 1,
        //   overflow: TextOverflow.ellipsis,
        //   style: AppStyles.s12Medium.copyWith(
        //     color: AppColors.white.withValues(alpha: 0.7),
        //   ),
        // ),
      ],
    );
  }
}