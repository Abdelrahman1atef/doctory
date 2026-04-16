import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_colors.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({super.key, this.value, this.onChange, this.color});

  final Color? color;
  final double? value;
  final ValueChanged<double>? onChange;

  @override
  Widget build(BuildContext context) {
    final double rating = value ?? 0.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.ltr,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            onChange?.call(index + 1.0);
          },
          child: Container(
            margin: EdgeInsets.only(right: index < 4 ? 4.0 : 0.0),
            child: Stack(
              children: [
                Icon(
                  Icons.star_border,
                  color: color ?? AppColors.white,
                  size: 20,
                ),
                if (rating > index)
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: (rating - index).clamp(0.0, 1.0),
                      child: Icon(
                        Icons.star,
                        color: color ?? AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
