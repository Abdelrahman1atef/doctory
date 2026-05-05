import 'dart:async';
import 'package:doctory/core/common/functions/location_helper.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/map_home/cubit/map_home_cubit.dart';
import 'package:doctory/features/map_home/cubit/map_home_states.dart';
import 'package:doctory/features/map_home/presentation/widgets/marker_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:doctory/features/map_home/presentation/sections/map_fabs_section.dart';

class MapSection extends StatefulWidget {
  final List<ClinicModel> clinics;
  final String? selectedClinicId;
  final ValueNotifier<double>? sheetSizeNotifier;

  const MapSection({
    super.key,
    required this.clinics,
    this.selectedClinicId,
    this.sheetSizeNotifier,
  });

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> _customMarkers = {};

  // Default to Mansoura
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(31.0409, 31.3785),
    zoom: 13.5,
  );

  @override
  void initState() {
    super.initState();
    _generateCustomMarkers();
    if (widget.clinics.isNotEmpty) {
      // Small delay to ensure controller is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitResults();
      });
    } else {
      _getCurrentLocation();
    }
  }

  @override
  void didUpdateWidget(MapSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clinics != oldWidget.clinics ||
        widget.selectedClinicId != oldWidget.selectedClinicId) {
      if (widget.clinics != oldWidget.clinics && widget.clinics.isNotEmpty) {
        _fitResults();
      }
      _generateCustomMarkers();
    }
  }

  Future<void> _generateCustomMarkers() async {
    final Set<Marker> newMarkers = {};
    for (int i = 0; i < widget.clinics.length; i++) {
      final clinic = widget.clinics[i];
      final String title = clinic.displayName;
      final bool isSelected = clinic.id == widget.selectedClinicId;

      final icon = await MarkerGenerator.createCustomMarkerBitmap(
        title,
        isSelected: isSelected,
        isRegistered: clinic.isRegistered,
      );

      newMarkers.add(
        Marker(
          markerId: MarkerId('${clinic.id}_$i'),
          position: LatLng(clinic.lat ?? 0.0, clinic.lng ?? 0.0),
          infoWindow: InfoWindow(title: clinic.displayName),
          icon: icon,
          onTap: () {
            context.read<MapHomeCubit>().selectClinic(clinic);
          },
        ),
      );
    }

    if (mounted) {
      setState(() {
        _customMarkers = newMarkers;
      });
    }
  }

  Future<void> _fitResults() async {
    final GoogleMapController controller = await _controller.future;

    if (widget.clinics.length == 1) {
      final clinic = widget.clinics.first;
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(clinic.lat ?? 0.0, clinic.lng ?? 0.0),
          15,
        ),
      );
    } else {
      LatLngBounds bounds = _calculateBounds(widget.clinics);
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  LatLngBounds _calculateBounds(List<ClinicModel> clinics) {
    double minLat = clinics.first.lat!;
    double maxLat = clinics.first.lat!;
    double minLng = clinics.first.lng!;
    double maxLng = clinics.first.lng!;

    for (var clinic in clinics) {
      if (clinic.lat! < minLat) minLat = clinic.lat!;
      if (clinic.lat! > maxLat) maxLat = clinic.lat!;
      if (clinic.lng! < minLng) minLng = clinic.lng!;
      if (clinic.lng! > maxLng) maxLng = clinic.lng!;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await LocationHelper.getCurrentLocation();
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14.5,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapHomeCubit, MapHomeStates>(
      listenWhen: (previous, current) {
        if (previous is MapHomeLoadedState && current is MapHomeLoadedState) {
          return previous.selectedClinic?.id != current.selectedClinic?.id;
        }
        return current is MapHomeLoadedState;
      },
      listener: (context, state) async {
        if (state is MapHomeLoadedState && state.selectedClinic != null) {
          final controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(
                state.selectedClinic!.lat ?? 0.0,
                state.selectedClinic!.lng ?? 0.0,
              ),
              15,
            ),
          );
        }
      },
      child: BlocBuilder<MapHomeCubit, MapHomeStates>(
        builder: (context, state) {
          Set<Polyline> polylines = {};
          if (state is MapHomeLoadedState &&
              state.route != null &&
              state.route!.geometry.isNotEmpty) {
            polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                points: state.route!.geometry,
                color: AppColors.stitchPrimaryContainer,
                width: 5,
              ),
            );
          }

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: _initialPosition,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                markerType: GoogleMapMarkerType.advancedMarker,
                markers: _customMarkers,
                polylines: polylines,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
              if (widget.sheetSizeNotifier != null)
                MapFabsSection(
                  sheetSizeNotifier: widget.sheetSizeNotifier!,
                  onMyLocationPressed: _getCurrentLocation,
                ),
            ],
          );
        },
      ),
    );
  }
}
