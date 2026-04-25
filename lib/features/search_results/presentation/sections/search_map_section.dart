import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/search_results/cubit/search_cubit.dart';
import 'package:doctory/features/search_results/cubit/search_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchMapSection extends StatefulWidget {
  const SearchMapSection({super.key});

  @override
  State<SearchMapSection> createState() => _SearchMapSectionState();
}

class _SearchMapSectionState extends State<SearchMapSection> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isMapReadyToBuild = false;
  double _mapOpacity = 0.0;
  String? _mapStyle;

  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(31.0409, 31.3785), // Default to Mansoura
    zoom: 13,
  );

  @override
  void initState() {
    super.initState();
    // Defer map creation and style loading using addPostFrameCallback 
    // to ensure context is ready for Theme.of(context) and first frame renders instantly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadMapStyle();
        setState(() {
          _isMapReadyToBuild = true;
        });
      }
    });
  }

  Future<void> _loadMapStyle() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final stylePath = !isDarkMode
        ? 'assets/json/map_dark_style.json' 
        : 'assets/json/map_light_style.json';
        
    final style = await DefaultAssetBundle.of(context).loadString(stylePath);
    if (mounted) {
      setState(() {
        _mapStyle = style;
      });
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    
    // Fade in the map once it's created and ready
    setState(() {
      _mapOpacity = 1.0;
    });
  }

  void _updateMarkersAndPolylines(SearchSuccessState state) {
    final newMarkers = state.hospitals.asMap().entries.map((entry) {
      final index = entry.key;
      final hospital = entry.value;
      final isSelected = state.selectedIndex == index;

      return Marker(
        markerId: MarkerId(hospital.id),
        position: LatLng(hospital.lat, hospital.lng),
        infoWindow: InfoWindow(
          title: hospital.displayName,
          snippet: hospital.distanceFormatted,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isSelected ? BitmapDescriptor.hueAzure : BitmapDescriptor.hueRed,
        ),
        onTap: () {
          context.read<SearchCubit>().selectHospital(index);
        },
      );
    }).toSet();

    // Update Polylines from OSRM points
    final newPolylines = <Polyline>{};
    if (state.routePoints != null && state.routePoints!.isNotEmpty) {
      newPolylines.add(
        Polyline(
          polylineId: const PolylineId('selected_hospital_route'),
          points: state.routePoints!,
          color: AppColors.stitchPrimary,
          width: 5,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      );
    }

    setState(() {
      _markers = newMarkers;
      _polylines = newPolylines;
    });

    // Camera animation logic
    if (state.routePoints != null && state.routePoints!.isNotEmpty) {
      _fitRoute(state.routePoints!);
    } else if (state.selectedIndex != null && state.hospitals.isNotEmpty) {
      final selectedHospital = state.hospitals[state.selectedIndex!];
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(selectedHospital.lat, selectedHospital.lng),
        ),
      );
    }
  }

  void _fitRoute(List<LatLng> points) {
    if (points.isEmpty) return;

    double? minLat, maxLat, minLng, maxLng;
    for (final p in points) {
      if (minLat == null || p.latitude < minLat) minLat = p.latitude;
      if (maxLat == null || p.latitude > maxLat) maxLat = p.latitude;
      if (minLng == null || p.longitude < minLng) minLng = p.longitude;
      if (maxLng == null || p.longitude > maxLng) maxLng = p.longitude;
    }

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat!, minLng!),
          northeast: LatLng(maxLat!, maxLng!),
        ),
        80, // padding
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchCubit, SearchStates>(
      listener: (context, state) {
        if (state is SearchSuccessState) {
          _updateMarkersAndPolylines(state);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
        child: Stack(
          children: [
            // Styled placeholder/shimmer
            if (!_isMapReadyToBuild || _mapOpacity == 0.0)
              Container(
                color: AppColors.stitchSurface,
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.stitchPrimary),
                ),
              ),

            // Google Map with fade-in animation
            if (_isMapReadyToBuild)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _mapOpacity,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: _initialPosition,
                  markers: _markers,
                  polylines: _polylines,
                  style: _mapStyle,
                  myLocationEnabled: false, // Permission confirmed before navigation
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

