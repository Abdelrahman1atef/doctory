import 'package:doctory/core/common/widgets/images/abher_image.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';

/// Doctor photo with a person-icon placeholder when no image is available.
class ClinicDoctorAvatarWidget extends StatelessWidget {
  final String? imageUrl;

  const ClinicDoctorAvatarWidget({super.key, this.imageUrl});

  static const double _size = 72;
  static const double _radius = 16;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url != null && url.isNotEmpty) {
      return AbherImage(
        url.toImageUrl,
        width: _size,
        height: _size,
        fit: BoxFit.cover,
        radius: _radius,
      );
    }

    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: AppColors.stitchPrimaryFixed.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: const Icon(
        Icons.person_rounded,
        color: AppColors.stitchPrimary,
        size: 36,
      ),
    );
  }
}
