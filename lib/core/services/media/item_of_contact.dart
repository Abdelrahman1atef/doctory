import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_colors.dart';

import '../../theme/app_typography.dart';

class ItemOfContact extends StatelessWidget {
  final void Function()? onTap;
  final bool choose, isImage;
  final String? title;
  const ItemOfContact({
    super.key,
    this.onTap,
    this.choose = false,
    this.title,
    this.isImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return (isImage)
        ? Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 21),
            decoration: BoxDecoration(
              color: choose ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: choose
                    ? Colors.transparent
                    : Colors.grey.withValues(alpha: .4),
              ),
            ),
            child: Row(
              children: [
                Text(
                  title ?? '',
                  style: AppStyles.s16Medium.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                choose
                    ? Icon(Icons.camera_alt_outlined, color: AppColors.primary)
                    : Icon(Icons.image_outlined, color: AppColors.primary),
              ],
            ),
          )
        : Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 21),
            height: 70,
            decoration: BoxDecoration(
              color: choose ? AppColors.secondary : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: choose
                    ? Colors.transparent
                    : Colors.grey.withValues(alpha: .4),
              ),
            ),
            child: Row(
              children: [
                Text(title ?? '', style: AppStyles.s16Medium),
                const Spacer(),
                choose
                    ? Image.asset(
                        'check-circle',
                        height: 30,
                        width: 30,
                        color: AppColors.primary,
                        fit: BoxFit.contain,
                      )
                    : Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.primary),
                          shape: BoxShape.circle,
                        ),
                      ),
              ],
            ),
          );
  }
}
