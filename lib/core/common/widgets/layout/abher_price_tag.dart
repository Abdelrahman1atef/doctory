import 'package:doctory/core/common/widgets/images/abher_image.dart';
import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';

class AbherPriceTag extends StatelessWidget {
  final String price;
  const AbherPriceTag({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 3,
      children: [
        Text(
          price,
          style: AppStyles.s14Medium.copyWith(color: AppColors.secondary),
        ),
        AbherImage('riyal'.svg(), width: 15, height: 15),
      ],
    );
  }
}
