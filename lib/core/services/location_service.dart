import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Possible states for location permission
enum LocationPermissionState {
  /// Haven't checked yet
  unknown,
  /// Permission granted (whileInUse or always)
  granted,
  /// User denied (can re-request)
  denied,
  /// User denied forever or service disabled (must go to Settings)
  deniedForever,
}

/// Single source of truth for location across the app.
/// Registered as a lazy singleton in GetIt.
class LocationService {
  // ─── Default Location: Mansoura, Egypt ───
  static const LatLng defaultLocation = LatLng(31.0409, 31.3785);

  // ─── Cached State ───
  LatLng? _cachedGpsPosition;
  LocationPermissionState _permissionState = LocationPermissionState.unknown;

  // ─── Coalescing futures (prevent duplicate platform calls) ───
  Future<LocationPermissionState>? _permissionFuture;
  Future<LatLng>? _positionFuture;

  // ─── Public Getters ───

  /// Current permission state (may be stale — call checkPermission() to refresh)
  LocationPermissionState get permissionState => _permissionState;

  /// Whether GPS permission is currently granted
  bool get isGranted => _permissionState == LocationPermissionState.granted;

  /// Best known position: GPS if available, otherwise Mansoura default.
  /// Synchronous — never blocks.
  LatLng get bestKnownPosition => _cachedGpsPosition ?? defaultLocation;

  // ─── Permission Methods ───

  /// Check permission without showing any system dialog.
  /// Safe to call from background, constructors, etc.
  Future<LocationPermissionState> checkPermission() {
    if (_permissionFuture != null) return _permissionFuture!;
    _permissionFuture = _checkPermissionInternal().whenComplete(() {
      _permissionFuture = null;
    });
    return _permissionFuture!;
  }

  Future<LocationPermissionState> _checkPermissionInternal() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _permissionState = LocationPermissionState.deniedForever;
        return _permissionState;
      }

      final permission = await Geolocator.checkPermission();
      _permissionState = _mapPermission(permission);
      return _permissionState;
    } catch (e) {
      debugPrint('📍 [LocationService] checkPermission error: $e');
      _permissionState = LocationPermissionState.denied;
      return _permissionState;
    }
  }

  /// Request permission — shows system dialog.
  /// Only call from user-initiated actions (button tap, etc.)
  Future<LocationPermissionState> requestPermission() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _permissionState = LocationPermissionState.deniedForever;
        return _permissionState;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      _permissionState = _mapPermission(permission);

      // If granted, pre-fetch position
      if (isGranted) {
        getPosition(); // Fire-and-forget, populates cache
      }

      return _permissionState;
    } catch (e) {
      debugPrint('📍 [LocationService] requestPermission error: $e');
      _permissionState = LocationPermissionState.denied;
      return _permissionState;
    }
  }

  // ─── Position Methods ───

  /// Get GPS position with timeout and fallback.
  /// Returns default location if permission denied or GPS fails.
  /// Coalesced — multiple callers share the same future.
  Future<LatLng> getPosition() {
    if (_positionFuture != null) return _positionFuture!;
    _positionFuture = _getPositionInternal().whenComplete(() {
      _positionFuture = null;
    });
    return _positionFuture!;
  }

  Future<LatLng> _getPositionInternal() async {
    if (!isGranted) return defaultLocation;

    try {
      // 1. Try last known (fast, no GPS fix needed)
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        _cachedGpsPosition = LatLng(lastKnown.latitude, lastKnown.longitude);
        return _cachedGpsPosition!;
      }

      // 2. Fresh GPS with strict 4s timeout
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 4));

      _cachedGpsPosition = LatLng(position.latitude, position.longitude);
      return _cachedGpsPosition!;
    } catch (e) {
      debugPrint('📍 [LocationService] getPosition error/timeout: $e');
      return _cachedGpsPosition ?? defaultLocation;
    }
  }

  /// Get a fresh high-accuracy position for navigation.
  /// Returns null if fails (caller decides fallback).
  Future<Position?> getFreshPosition() async {
    if (!isGranted) return null;
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 4));
    } catch (e) {
      debugPrint('📍 [LocationService] getFreshPosition error: $e');
      return null;
    }
  }

  // ─── Helpers ───

  LocationPermissionState _mapPermission(LocationPermission permission) {
    return switch (permission) {
      LocationPermission.always => LocationPermissionState.granted,
      LocationPermission.whileInUse => LocationPermissionState.granted,
      LocationPermission.denied => LocationPermissionState.denied,
      LocationPermission.deniedForever => LocationPermissionState.deniedForever,
      _ => LocationPermissionState.denied,
    };
  }
}
