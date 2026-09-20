import 'package:doctory/core/common/widgets/loading/app_shimmer.dart';
import 'package:flutter/material.dart';

/// Placeholder mirroring the booking-config form: four fields and a button.
class BookingConfigShimmerWidget extends StatelessWidget {
  const BookingConfigShimmerWidget({super.key});

  static const int _fieldCount = 4;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          for (var i = 0; i < _fieldCount; i++) ...[
            const ShimmerContainer(width: 140, height: 16),
            const SizedBox(height: 8),
            const ShimmerContainer(height: 56, radius: 12),
            const SizedBox(height: 20),
          ],
          const SizedBox(height: 12),
          const ShimmerContainer(height: 56, radius: 12),
        ],
      ),
    );
  }
}
