import 'package:flutter/material.dart';

/// Pure widget — manages the layout of the Google Map and its floating action buttons
class MapContentWidget extends StatelessWidget {
  final Widget mapWidget;

  const MapContentWidget({
    super.key,
    required this.mapWidget,
  });

  @override
  Widget build(BuildContext context) {
    return mapWidget;
  }
}
