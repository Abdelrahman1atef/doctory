import 'package:flutter/material.dart';

/// Pure widget — manages the layout of the Google Map and its floating action buttons
class MapContentWidget extends StatelessWidget {
  final Widget mapWidget;
  final Widget fabWidget;

  const MapContentWidget({
    super.key,
    required this.mapWidget,
    required this.fabWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        mapWidget,
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.35 + 16,
          right: 16,
          child: fabWidget,
        ),
      ],
    );
  }
}
