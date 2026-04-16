import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A pure UI widget that displays a Google Map with a centre-pin.
/// The parent is responsible for hosting this widget in any layout;
/// it emits picked coordinates + a human-readable address via callbacks.
///
/// Usage:
/// ```dart
/// MapPickerWidget(
///   onLocationPicked: (lat, lng, address) { ... },
/// )
/// ```
class MapPickerWidget extends StatefulWidget {
  /// Emitted whenever the user stops moving the camera.
  final void Function(double lat, double lng, String address) onLocationPicked;

  /// Initial map centre. Defaults to Riyadh.
  final LatLng initialPosition;

  /// Initial zoom level.
  final double initialZoom;

  /// Optional list of markers to show on the map.
  final Set<Marker>? markers;

  const MapPickerWidget({
    super.key,
    required this.onLocationPicked,
    this.initialPosition = const LatLng(24.7136, 46.6753),
    this.initialZoom = 15,
    this.markers,
  });

  @override
  State<MapPickerWidget> createState() => _MapPickerWidgetState();
}

class _MapPickerWidgetState extends State<MapPickerWidget> {
  GoogleMapController? _controller;
  LatLng _current = const LatLng(24.7136, 46.6753);
  String _address = '';
  bool _loadingAddress = false;
  bool _loadingLocation = false;

  @override
  void initState() {
    super.initState();
    _current = widget.initialPosition;
    _fetchCurrentLocation();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ── Location Helpers ────────────────────────────────────────────────────────

  Future<void> _fetchCurrentLocation() async {
    if (!mounted) return;
    setState(() => _loadingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final pos = await Geolocator.getCurrentPosition();
        final latLng = LatLng(pos.latitude, pos.longitude);
        _current = latLng;
        _controller?.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, widget.initialZoom),
        );
        await _reverseGeocode(latLng);
      }
    } catch (_) {
      // Keep default position on error
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  Future<void> _reverseGeocode(LatLng latLng) async {
    if (!mounted) return;
    setState(() => _loadingAddress = true);
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final address = [
          p.locality,
          p.thoroughfare,
        ].where((s) => s != null && s.isNotEmpty).join(' , ');
        if (mounted) {
          setState(() => _address = address);
          widget.onLocationPicked(latLng.latitude, latLng.longitude, address);
        }
      }
    } catch (_) {
      if (mounted) setState(() => _address = '');
    } finally {
      if (mounted) setState(() => _loadingAddress = false);
    }
  }

  // ── Map Callbacks ────────────────────────────────────────────────────────────

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    if (widget.markers != null && widget.markers!.isNotEmpty) {
      _centerCameraOnMarkers();
    }
  }

  void _centerCameraOnMarkers() {
    if (_controller == null ||
        widget.markers == null ||
        widget.markers!.isEmpty) {
      return;
    }

    double minLat = widget.markers!.first.position.latitude;
    double maxLat = widget.markers!.first.position.latitude;
    double minLng = widget.markers!.first.position.longitude;
    double maxLng = widget.markers!.first.position.longitude;

    for (var marker in widget.markers!) {
      if (marker.position.latitude < minLat) minLat = marker.position.latitude;
      if (marker.position.latitude > maxLat) maxLat = marker.position.latitude;
      if (marker.position.longitude < minLng) {
        minLng = marker.position.longitude;
      }
      if (marker.position.longitude > maxLng) {
        maxLng = marker.position.longitude;
      }
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _controller?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  void _onCameraMove(CameraPosition position) {
    _current = position.target;
  }

  void _onCameraIdle() {
    _reverseGeocode(_current);
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Address chip
        if (_address.isNotEmpty || _loadingAddress)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.lightWhite,
              // border: Border.all(color: AppColors.primaryTeal),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primaryTeal,
                  size: 20,
                ),
                8.pw,
                Flexible(
                  child: _loadingAddress
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _address,
                          style: AppStyles.s14Bold.withColor(
                            AppColors.primaryNavy,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ],
            ),
          ),
        12.ph,

        // Map
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _current,
                    zoom: widget.initialZoom,
                  ),
                  onMapCreated: _onMapCreated,
                  onCameraMove: _onCameraMove,
                  onCameraIdle: _onCameraIdle,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  markers: widget.markers ?? {},
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                ),

                // Centre pin (only show if no markers, or keep as picker?)
                // Usually a picker has a centre pin. If there are markers, maybe hide it?
                // Let's keep it for now as it's a "Picker".
                if (widget.markers == null || widget.markers!.isEmpty)
                  const Icon(
                    Icons.location_pin,
                    color: AppColors.primaryTeal,
                    size: 40,
                  ),

                // Loading overlay
                if (_loadingLocation)
                  Container(
                    color: Colors.white54,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
