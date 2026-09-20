import 'package:doctory/core/common/widgets/loading/app_shimmer.dart';
import 'package:flutter/material.dart';

/// Placeholder mirroring the availability cards while the list loads.
class AvailabilityShimmerWidget extends StatelessWidget {
  const AvailabilityShimmerWidget({super.key});

  static const int _cardCount = 3;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        itemCount: _cardCount,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, _) => const ShimmerContainer(height: 88, radius: 12),
      ),
    );
  }
}
