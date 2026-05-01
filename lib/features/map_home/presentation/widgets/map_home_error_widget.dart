import 'package:flutter/material.dart';

/// Pure widget — displays an error message on the Map
class MapHomeErrorWidget extends StatelessWidget {
  final String message;

  const MapHomeErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
