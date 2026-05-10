import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class UnreadBadgeWidget extends StatelessWidget {
  final int count;

  const UnreadBadgeWidget({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
