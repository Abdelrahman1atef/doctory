import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Pure widget — displays loading animation for the Map
class MapHomeLoadingWidget extends StatelessWidget {
  const MapHomeLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.8),
      child: Center(
        child: Lottie.asset(
          'assets/lottie/Search Doctor.json',
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
