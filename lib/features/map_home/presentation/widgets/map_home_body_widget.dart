import 'package:flutter/material.dart';

class MapHomeBodyWidget extends StatelessWidget {
  final Widget mapSection;
  final Widget searchSection;
  final Widget? bottomSheetSection;
  final Widget? loadingOverlay;
  final Widget? errorOverlay;
  final Widget? emptyOverlay;
  final Widget? locationBanner;

  const MapHomeBodyWidget({
    super.key,
    required this.mapSection,
    required this.searchSection,
    this.bottomSheetSection,
    this.loadingOverlay,
    this.errorOverlay,
    this.emptyOverlay,
    this.locationBanner,
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
        if (emptyOverlay != null) emptyOverlay!,
        if (locationBanner != null) locationBanner!,
      ],
    );
  }
}
