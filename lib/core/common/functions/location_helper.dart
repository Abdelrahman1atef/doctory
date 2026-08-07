import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationHelper {
  static const LatLng defaultLocation = LatLng(31.0409, 31.3785);

  static Future<bool>? _permissionFuture;
  static Future<LatLng>? _locationFuture;

  static Future<bool> checkAndRequestPermission() {
    if (_permissionFuture != null) return _permissionFuture!;
    _permissionFuture = _checkAndRequestPermissionInternal().whenComplete(() {
      _permissionFuture = null;
    });
    return _permissionFuture!;
  }

  static Future<bool> _checkAndRequestPermissionInternal() async {
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

  static Future<bool> isPermissionGranted() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  static Future<LatLng> getCurrentLocation() {
    if (_locationFuture != null) return _locationFuture!;
    _locationFuture = _getCurrentLocationInternal().whenComplete(() {
      _locationFuture = null;
    });
    return _locationFuture!;
  }

  static Future<LatLng> _getCurrentLocationInternal() async {
    try {
      // Only CHECK permission — never REQUEST it from background flows.
      // Requesting shows a system dialog that can pop over the map/home
      // mid-layout and block the UI on some Android devices.
      final hasPermission = await isPermissionGranted();
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
      final position =
          await Geolocator.getCurrentPosition(
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

  static Future<void> getLatLongData() async {}
}
