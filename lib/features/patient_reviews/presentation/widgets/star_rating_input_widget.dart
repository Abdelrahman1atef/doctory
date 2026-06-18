import 'package:doctory/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StarRatingInputWidget extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;
  final double size;

  const StarRatingInputWidget({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
              color: index < rating ? Colors.amber : AppColors.stitchSurfaceLow,
              size: size,
            ),
          ),
        );
      }),
    );
  }
}
