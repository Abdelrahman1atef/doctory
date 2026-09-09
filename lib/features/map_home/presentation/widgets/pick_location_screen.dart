import 'package:doctory/core/common/functions/location_helper.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Full-screen map for picking a custom search location
class PickLocationScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const PickLocationScreen({super.key, this.initialLocation});

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  LatLng? _pickedLocation;
  late CameraPosition _initialCamera;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _pickedLocation = widget.initialLocation;
      _initialCamera = CameraPosition(target: widget.initialLocation!, zoom: 14);
    } else {
      _initialCamera = const CameraPosition(target: LocationHelper.defaultLocation, zoom: 14);
      _initFromGps();
    }
  }

  Future<void> _initFromGps() async {
    final pos = await LocationHelper.getCurrentLocation();
    if (!mounted) return;
    _pickedLocation = pos;
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(pos, 14));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'pick_location'.tr(),
          style: AppStyles.s18Bold.withColor(AppColors.stitchPrimaryContainer),
        ),
        backgroundColor: AppColors.stitchSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.stitchPrimaryContainer,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCamera,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (controller) => _mapController = controller,
            onTap: (latLng) {
              setState(() {
                _pickedLocation = latLng;
              });
            },
            markers: _pickedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('picked'),
                      position: _pickedLocation!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueAzure,
                      ),
                    ),
                  }
                : {},
          ),
          // Confirm button at the bottom
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _pickedLocation != null
                    ? () => Navigator.pop(context, _pickedLocation)
                    : null,
                icon: const Icon(Icons.check, color: Colors.white),
                label: Text(
                  'confirm_location'.tr(),
                  style: AppStyles.s16Bold.withColor(Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.stitchPrimaryContainer,
                  disabledBackgroundColor: AppColors.stitchSurfaceLow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
