import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationHelper {
  static const LatLng defaultLocation = LatLng(27.910000, 34.333000);

  static Future<bool> checkAndRequestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('📍 [LocationHelper] Location services disabled');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('📍 [LocationHelper] Permission denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('📍 [LocationHelper] Permission denied forever');
      return false;
    }

    return true;
  }

  static Future<LatLng> getCurrentLocation() async {
    try {
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) return defaultLocation;

      debugPrint(
        '📍 [LocationHelper] Fetching location: Checking last known...',
      );
      // 1. Try last known position first (fastest)
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        debugPrint(
          '📍 [LocationHelper] Last known position found: ${lastKnown.latitude}, ${lastKnown.longitude}',
        );
        return LatLng(lastKnown.latitude, lastKnown.longitude);
      }

      debugPrint(
        '📍 [LocationHelper] No last known. Fetched current position...',
      );

      // 2. High accuracy fresh position with a strict timeout
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(
        const Duration(seconds: 4), // Reduced from 5 to 4 for better UX
        onTimeout: () {
          debugPrint('📍 [LocationHelper] Timeout: No position fix');
          throw Exception('Location timeout');
        },
      );

      debugPrint(
        '📍 [LocationHelper] Fresh position: ${position.latitude}, ${position.longitude}',
      );
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('📍 [LocationHelper] Error/Timeout: Using fallback: $e');
      return defaultLocation;
    }
  }

  static Future<String> getAddressFromLatLng(LatLng position) async {
    try {
      debugPrint(
        '📍 [LocationHelper] Fetching address for: ${position.latitude}, ${position.longitude}',
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(const Duration(seconds: 3));

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Construct a readable address: "Street, Locality" or "Locality, Country"
        String street = place.street ?? '';
        String subLocality = place.subLocality ?? '';
        String locality = place.locality ?? '';

        if (subLocality.isNotEmpty && locality.isNotEmpty) {
          return "$subLocality, $locality";
        } else if (street.isNotEmpty && locality.isNotEmpty) {
          return "$street, $locality";
        } else {
          return locality.isNotEmpty ? locality : (place.name ?? '');
        }
      }
    } catch (e) {
      // Fallback
    }
    return "";
  }

  // Navigation points for in-app routing are fetched via getRoutePoints below.

  static Future<List<LatLng>> getRoutePoints({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    try {
      // Use OSRM Public API (Demo server)
      // Format: http://router.project-osrm.org/route/v1/driving/sourceLng,sourceLat;destLng,destLat?overview=full&geometries=geojson
      final url = 'https://router.project-osrm.org/route/v1/driving/$startLng,$startLat;$endLng,$endLat?overview=full&geometries=geojson';
      
      final dio = Dio();
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];
        
        // OSRM returns [lng, lat], convert to LatLng(lat, lng)
        return coordinates.map((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble())).toList();
      }
    } catch (e) {
      debugPrint('📍 [LocationHelper] Error fetching route points: $e');
    }
    return [];
  }

  static Future<void> getLatLongData() async {}
}
