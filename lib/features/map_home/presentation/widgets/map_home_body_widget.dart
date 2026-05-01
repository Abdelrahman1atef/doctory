import 'package:flutter/material.dart';

/// Pure widget — manages the structural layout (Stack) for the MapHome screen
class MapHomeBodyWidget extends StatelessWidget {
  final Widget mapSection;
  final Widget searchSection;
  final Widget? loadingOverlay;
  final Widget? errorOverlay;

  const MapHomeBodyWidget({
    super.key,
    required this.mapSection,
    required this.searchSection,
    this.loadingOverlay,
    this.errorOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        mapSection,
        searchSection,
        if (loadingOverlay != null) loadingOverlay!,
        if (errorOverlay != null) errorOverlay!,
      ],
    );
  }
}
