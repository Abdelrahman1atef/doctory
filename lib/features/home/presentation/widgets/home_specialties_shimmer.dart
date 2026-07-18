import 'package:doctory/core/common/widgets/loading/app_shimmer.dart';
import 'package:flutter/material.dart';

class HomeSpecialtiesShimmer extends StatelessWidget {
  const HomeSpecialtiesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16).copyWith(top: 16, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerContainer(width: 100, height: 16),
            const SizedBox(height: 16),
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShimmerContainer(width: 48, height: 48, radius: 24),
                      const SizedBox(width: 12),
                      ShimmerContainer(width: 60, height: 14),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
