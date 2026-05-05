import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteModel {
  final double distance;
  final double duration;
  final List<LatLng> geometry;

  RouteModel({
    required this.distance,
    required this.duration,
    required this.geometry,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return RouteModel(
      distance: (data['distance'] ?? 0.0).toDouble(),
      duration: (data['duration'] ?? 0.0).toDouble(),
      geometry:
          (data['geometry'] as List?)
              ?.map(
                (e) =>
                    LatLng((e[1] as num).toDouble(), (e[0] as num).toDouble()),
              )
              .toList() ??
          [],
    );
  }
}
