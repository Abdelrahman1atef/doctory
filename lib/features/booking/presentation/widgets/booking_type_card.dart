import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class BookingTypeCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const BookingTypeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<BookingTypeCard> createState() => _BookingTypeCardState();
}

class _BookingTypeCardState extends State<BookingTypeCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? AppColors.stitchPrimaryFixed.withValues(alpha: 0.15)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: widget.isSelected
                    ? AppColors.stitchPrimary
                    : AppColors.grey200,
                width: widget.isSelected ? 2 : 1,
              ),
            ),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? AppColors.stitchPrimary
                        : AppColors.grey100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon,
                    color: widget.isSelected
                        ? AppColors.white
                        : AppColors.grey600,
                    size: 24,
                  ),
                ),
                16.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedDefaultTextStyle(
                        style: AppStyles.s16Bold.withColor(
                          widget.isSelected
                              ? AppColors.stitchPrimary
                              : AppColors.stitchPrimaryContainer,
                        ),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        child: Text(widget.title),
                      ),
                      4.ph,
                      Text(widget.subtitle,
                        style: AppStyles.s13Medium.withColor(AppColors.grey500),
                      ),
                    ],
                  ),
                ),
                AnimatedScale(
                  scale: widget.isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.elasticOut,
                  child: AnimatedOpacity(
                    opacity: widget.isSelected ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.check_circle,
                      color: AppColors.stitchPrimary,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
