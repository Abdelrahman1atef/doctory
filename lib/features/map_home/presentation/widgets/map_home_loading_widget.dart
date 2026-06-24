import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Pure widget — displays loading animation for the Map
class MapHomeLoadingWidget extends StatelessWidget {
  final VoidCallback? onCancel;

  const MapHomeLoadingWidget({super.key, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/lottie/Search Doctor.json',
              width: 250,
              height: 250,
            ),
            if (onCancel != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close),
                  label: const Text('Cancel'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
