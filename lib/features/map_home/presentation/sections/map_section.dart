import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
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
  GoogleMapController? _mapController;
  Set<Marker> _customMarkers = {};
  Set<Polyline> _cachedPolylines = {};
  List<LatLng>? _lastPolylineCoords;
  String? _mapStyle;
  Brightness? _currentBrightness;

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
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = Theme.of(context).brightness;
    if (_currentBrightness != brightness) {
      _currentBrightness = brightness;
      MarkerGenerator.clearCache();
      _loadMapStyle();
    }
  }

  Future<void> _loadMapStyle() async {
    final isDark = _currentBrightness == Brightness.dark;
    final stylePath = isDark
        ? 'assets/json/map_dark_style.json'
        : 'assets/json/map_light_style.json';

    try {
      final style = await rootBundle.loadString(stylePath);
      if (mounted) {
        setState(() {
          _mapStyle = style;
        });
      }
    } catch (e) {
      debugPrint('Error loading map style: $e');
    }
  }

  @override
  void didUpdateWidget(MapSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final currentState = context.read<MapHomeCubit>().state;
    final isNavigating =
        currentState is MapHomeLoadedState && currentState.isNavigating;

    if (widget.clinics != oldWidget.clinics ||
        widget.selectedClinicId != oldWidget.selectedClinicId) {
      if (widget.clinics != oldWidget.clinics &&
          widget.clinics.isNotEmpty &&
          !isNavigating) {
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
    final currentState = context.read<MapHomeCubit>().state;
    if (currentState is MapHomeLoadedState && currentState.isNavigating) {
      debugPrint(
        '📍 [MapSection] Skipping fitResults because navigation is active',
      );
      return;
    }

    final GoogleMapController? controller = _mapController;
    if (controller == null) return;

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
      final GoogleMapController? controller = _mapController;
      if (controller == null) return;
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
          final clinicChanged =
              previous.selectedClinic?.id != current.selectedClinic?.id;
          final navToggled = previous.isNavigating != current.isNavigating;
          final userMovedWhileNav =
              current.isNavigating &&
              (previous.currentUserLat != current.currentUserLat ||
                  previous.currentUserLng != current.currentUserLng ||
                  previous.currentUserHeading != current.currentUserHeading);

          return clinicChanged || navToggled || userMovedWhileNav;
        }
        return current is MapHomeLoadedState;
      },
      listener: (context, state) async {
        if (state is MapHomeLoadedState) {
          final controller = _mapController;
          if (controller == null) return;
          if (state.isNavigating &&
              state.currentUserLat != null &&
              state.currentUserLng != null) {
            // Navigation mode: follow user with tilt
            controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(state.currentUserLat!, state.currentUserLng!),
                  zoom: 18,
                  tilt: 0, // Enforce 2D view (no tilt)
                  bearing: state.currentUserHeading ?? 0,
                ),
              ),
            );
          } else if (state.selectedClinic != null) {
            // Clinic selected but not navigating: center on clinic
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
        }
      },
      child: BlocBuilder<MapHomeCubit, MapHomeStates>(
        buildWhen: (prev, curr) {
          if (prev.runtimeType != curr.runtimeType) return true;
          if (prev is MapHomeLoadedState && curr is MapHomeLoadedState) {
            return prev.route != curr.route ||
                prev.isNavigating != curr.isNavigating;
          }
          return true;
        },
        builder: (context, state) {
          if (state is MapHomeLoadedState &&
              state.route != null &&
              state.route!.geometry.isNotEmpty) {
            final coords = state.route!.geometry;
            if (coords != _lastPolylineCoords) {
              _lastPolylineCoords = coords;
              _cachedPolylines = {
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: coords,
                  color: AppColors.stitchPrimaryContainer,
                  width: 5,
                ),
              };
            }
          } else {
            _lastPolylineCoords = null;
            _cachedPolylines = {};
          }

          return Stack(
            children: [
              GoogleMap(
                key: const ValueKey('main_google_map'),
                initialCameraPosition: _initialPosition,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                markerType: GoogleMapMarkerType.advancedMarker,
                markers: _customMarkers,
                polylines: _cachedPolylines,
                style: _mapStyle,
                buildingsEnabled: false,
                indoorViewEnabled: false,
                tiltGesturesEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
              ),
              if (widget.sheetSizeNotifier != null)
                MapFabsSection(
                  sheetSizeNotifier: widget.sheetSizeNotifier!,
                  onMyLocationPressed: _getCurrentLocation,
                ),
              if (state is MapHomeLoadedState && state.isNavigating)
                Positioned(
                  top: 16,
                  left: 16,
                  child: SafeArea(
                    child: IconButton.filled(
                      onPressed: () {
                        context.read<MapHomeCubit>().stopNavigation();
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.errorColor,
                        padding: const EdgeInsets.all(12),
                      ),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
