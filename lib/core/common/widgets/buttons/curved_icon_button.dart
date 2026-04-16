import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';

class CurvedIconButton extends StatelessWidget {
  const CurvedIconButton({
    super.key,
    required this.onTap,
    required this.title,
    this.icon,
  });

  final VoidCallback onTap;
  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            bottomRight: Radius.circular(30),
            bottomLeft: Radius.circular(10),
          ),
        ),
        child: Center(
          child: Row(
            children: [
              12.ph,
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: icon != null
                      ? const Icon(
                          null,
                          size: 22,
                          color: AppColors.white,
                        ) // Using icon variable correctly
                      : const Icon(
                          Icons.shopping_bag_outlined,
                          size: 22,
                          color: AppColors.white,
                        ),
                ),
              ),
              const Spacer(flex: 3),
              Text(
                title,
                style: AppStyles.s14Medium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }
}
