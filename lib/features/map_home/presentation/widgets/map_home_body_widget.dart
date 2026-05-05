import 'package:flutter/material.dart';

/// Pure widget — manages the structural layout (Stack) for the MapHome screen
class MapHomeBodyWidget extends StatelessWidget {
  final Widget mapSection;
  final Widget searchSection;
  final Widget? bottomSheetSection;
  final Widget? loadingOverlay;
  final Widget? errorOverlay;

  const MapHomeBodyWidget({
    super.key,
    required this.mapSection,
    required this.searchSection,
    this.bottomSheetSection,
    this.loadingOverlay,
    this.errorOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        KeyedSubtree(
          key: const ValueKey('map_section_subtree'),
          child: mapSection,
        ),
        if (bottomSheetSection != null) bottomSheetSection!,
        searchSection,
        if (loadingOverlay != null) loadingOverlay!,
        if (errorOverlay != null) errorOverlay!,
      ],
    );
  }
}
