import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_colors.dart';

class AdsBannerBackgroundWidget extends StatelessWidget {
  final String? imageUrl;
  final String clinicName;

  const AdsBannerBackgroundWidget({
    super.key,
    required this.imageUrl,
    required this.clinicName,
  });

  bool get _hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (_hasImage) {
      return CachedNetworkImage(
        imageUrl: imageUrl!.toImageUrl,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) =>
            const _AdBannerFillWidget(),
      );
    }
    return const _AdBannerFillWidget();
  }
}

class _AdBannerFillWidget extends StatelessWidget {
  const _AdBannerFillWidget();

  static const LinearGradient _gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.adBannerGradientStart,
      AppColors.adBannerGradientEnd,
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: _gradient,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: SizedBox.expand(),
    );
  }
}