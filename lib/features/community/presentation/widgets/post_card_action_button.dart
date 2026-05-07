import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class PostCardActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Function(LongPressStartDetails)? onLongPressStart;
  final Color color;

  const PostCardActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.onLongPressStart,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: onLongPressStart,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            8.pw,
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
