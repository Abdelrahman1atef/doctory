import 'dart:async';
import 'package:doctory/core/common/functions/location_helper.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/map_home/cubit/map_home_cubit.dart';
import 'package:doctory/features/map_home/cubit/map_home_states.dart';
import 'package:doctory/features/map_home/presentation/widgets/map_location_fab_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSection extends StatefulWidget {
  final List<ClinicModel> clinics;

  const MapSection({super.key, required this.clinics});

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // Default to Mansoura
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(31.0409, 31.3785),
    zoom: 13.5,
  );

  @override
  void initState() {
    super.initState();
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
    if (widget.clinics != oldWidget.clinics && widget.clinics.isNotEmpty) {
      _fitResults();
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
    // Generate markers from current clinics
    final Set<Marker> markers = widget.clinics.map((clinic) {
      return Marker(
        markerId: MarkerId(clinic.id),
        position: LatLng(clinic.lat ?? 0.0, clinic.lng ?? 0.0),
        infoWindow: InfoWindow(title: clinic.displayName),
        onTap: () {
          context.read<MapHomeCubit>().selectClinic(clinic);
        },
      );
    }).toSet();

    return BlocListener<MapHomeCubit, MapHomeStates>(
      listenWhen: (previous, current) {
        if (previous is MapHomeLoaded && current is MapHomeLoaded) {
          return previous.selectedClinic?.id != current.selectedClinic?.id;
        }
        return current is MapHomeLoaded;
      },
      listener: (context, state) async {
        if (state is MapHomeLoaded && state.selectedClinic != null) {
          final controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(state.selectedClinic!.lat ?? 0.0,
                  state.selectedClinic!.lng ?? 0.0),
              15,
            ),
          );
        }
      },
      child: BlocBuilder<MapHomeCubit, MapHomeStates>(
        builder: (context, state) {
          Set<Polyline> polylines = {};
          if (state is MapHomeLoaded && state.routePoints.isNotEmpty) {
            polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                points: state.routePoints.cast<LatLng>(),
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
                markers: markers,
                polylines: polylines,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.35 + 16,
                right: 16,
                child: MapLocationFabWidget(onPressed: _getCurrentLocation),
              ),
            ],
          );
        },
      ),
    );
  }
}
