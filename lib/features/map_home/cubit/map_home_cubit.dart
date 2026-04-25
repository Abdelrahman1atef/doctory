import 'dart:async';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/features/map_home/data/data_source/map_home_mock_data.dart';
import 'package:doctory/features/map_home/cubit/map_home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/common/functions/location_helper.dart';
import 'package:flutter/foundation.dart';

class MapHomeCubit extends Cubit<MapHomeStates> {
  MapHomeCubit() : super(MapHomeInitial());

  List<ClinicModel> _allClinics = [];
  ClinicModel? _selectedClinic;
  Timer? _routeUpdateTimer;

  void fetchNearbyClinics({String? query}) async {
    emit(MapHomeLoading());
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      _allClinics = MapHomeMockData.nearbyClinics;

      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        _allClinics = _allClinics.where((clinic) {
          final inName = clinic.name.toLowerCase().contains(q);
          final inNameAr = clinic.nameAr?.toLowerCase().contains(q) ?? false;
          final inAddress = clinic.address?.toLowerCase().contains(q) ?? false;
          final inAddressAr = clinic.addressAr?.toLowerCase().contains(q) ?? false;
          final inSpecialties = clinic.specialties?.any((s) => s.toLowerCase().contains(q)) ?? false;

          return inName || inNameAr || inAddress || inAddressAr || inSpecialties;
        }).toList();
      }

      emit(MapHomeLoaded(clinics: _allClinics, query: query));
    } catch (e) {
      emit(MapHomeError('Failed to load clinics'));
    }
  }

  void getUserLocationAndSearch({String? query}) async {
    emit(MapHomeLoading());
    try {
      await LocationHelper.getCurrentLocation();
      // In a real app, you'd send lat/lng to the API
      fetchNearbyClinics(query: query);
    } catch (e) {
      fetchNearbyClinics(query: query); // Fallback to fetching anyway
    }
  }

  void selectClinic(ClinicModel? clinic) async {
    _selectedClinic = clinic;
    _routeUpdateTimer?.cancel(); // Cancel any existing timer

    final currentState = state;
    if (currentState is MapHomeLoaded) {
      emit(currentState.copyWith(
          selectedClinic: _selectedClinic, routePoints: []));

      if (_selectedClinic != null) {
        _updateRoute(); // Initial update
        
        // Setup periodic update every 2 seconds
        _routeUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
          _updateRoute();
        });
      }
    }
  }

  Future<void> _updateRoute() async {
    if (_selectedClinic == null) return;

    try {
      final userLocation = await LocationHelper.getCurrentLocation();
      final points = await LocationHelper.getRoutePoints(
        startLat: userLocation.latitude,
        startLng: userLocation.longitude,
        endLat: _selectedClinic!.lat ?? 0.0,
        endLng: _selectedClinic!.lng ?? 0.0,
      );

      if (state is MapHomeLoaded) {
        emit((state as MapHomeLoaded).copyWith(routePoints: points));
      }
    } catch (e) {
      debugPrint('Error updating route: $e');
    }
  }

  @override
  Future<void> close() {
    _routeUpdateTimer?.cancel();
    return super.close();
  }
}
