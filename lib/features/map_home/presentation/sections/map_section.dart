import 'dart:async';
import 'dart:math';
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
import 'package:doctory/features/map_home/presentation/widgets/map_nav_info_widget.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
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
      _generateCustomMarkers();
    }

    if (widget.selectedClinicId != null &&
        widget.selectedClinicId != oldWidget.selectedClinicId &&
        !isNavigating) {
      final clinic = widget.clinics.cast<ClinicModel?>().firstWhere(
        (c) => c?.id == widget.selectedClinicId,
        orElse: () => null,
      );
      if (clinic != null) {
        _focusOnUserAndClinic(clinic);
      }
    }
  }

  Future<void> _generateCustomMarkers() async {
    final Set<Marker> newMarkers = {};
    final clinicsToShow = widget.selectedClinicId != null
        ? widget.clinics.where((c) => c.id == widget.selectedClinicId).toList()
        : widget.clinics;
    for (int i = 0; i < clinicsToShow.length; i++) {
      final clinic = clinicsToShow[i];
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

  Future<void> _focusOnUserAndClinic(ClinicModel clinic) async {
    final controller = _mapController;
    if (controller == null) return;

    final selectedId = widget.selectedClinicId;
    final clinicPos = LatLng(clinic.lat ?? 0.0, clinic.lng ?? 0.0);

    LatLng? userPos;
    final state = context.read<MapHomeCubit>().state;
    if (state is MapHomeLoadedState && state.currentUserLat != null) {
      userPos = LatLng(state.currentUserLat!, state.currentUserLng!);
    } else {
      try {
        final position = await LocationHelper.getCurrentLocation();
        userPos = LatLng(position.latitude, position.longitude);
      } catch (_) {}
    }

    if (mounted && widget.selectedClinicId != selectedId) return;

    if (userPos != null) {
      final bounds = LatLngBounds(
        southwest: LatLng(
          min(userPos.latitude, clinicPos.latitude),
          min(userPos.longitude, clinicPos.longitude),
        ),
        northeast: LatLng(
          max(userPos.latitude, clinicPos.latitude),
          max(userPos.longitude, clinicPos.longitude),
        ),
      );
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    } else {
      controller.animateCamera(CameraUpdate.newLatLngZoom(clinicPos, 15));
    }
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
          final navToggled = previous.isNavigating != current.isNavigating;
          final userMovedWhileNav =
              current.isNavigating &&
              (previous.currentUserLat != current.currentUserLat ||
                  previous.currentUserLng != current.currentUserLng ||
                  previous.currentUserHeading != current.currentUserHeading);

          return navToggled || userMovedWhileNav;
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
                onTap: (_) => FocusScope.of(context).unfocus(),
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
              ),
              if (widget.sheetSizeNotifier != null)
                MapFabsSection(
                  sheetSizeNotifier: widget.sheetSizeNotifier!,
                  onMyLocationPressed: _getCurrentLocation,
                ),
              if (state is MapHomeLoadedState &&
                  state.isNavigating &&
                  state.route != null &&
                  state.selectedClinic != null)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: MapNavInfoWidget(
                    clinic: state.selectedClinic!,
                    route: state.route!,
                    onStop: () {
                      context.read<MapHomeCubit>().stopNavigation();
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
