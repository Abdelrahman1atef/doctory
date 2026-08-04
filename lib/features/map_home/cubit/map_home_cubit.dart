import 'dart:async';
import 'package:doctory/core/common/models/clinic_model.dart';
import 'package:doctory/core/common/functions/location_helper.dart';
import 'package:doctory/core/error/failures.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/features/map_home/cubit/map_home_states.dart';
import 'package:doctory/features/map_home/data/repo/map_home_repo.dart';
import 'package:doctory/shared/cubit/specializations_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

import '../../../core/common/models/specialty_model.dart';

class MapHomeCubit extends Cubit<MapHomeStates> {
  final MapHomeRepo _mapHomeRepo;
  bool _isLiveNavigating = false;
  ClinicModel? _navigatingClinic;
  MapHomeLoadedState? _previousLoadedState;

  LatLng? _cachedPosition;
  List<SpecialtyModel>? _pendingSpecializations;
  CancelToken? _searchCancelToken;
  CancelToken? _routeCancelToken;
  Timer? _debounce;
  StreamSubscription<SharedSpecializationsState>? _specSub;

  MapHomeCubit(this._mapHomeRepo) : super(MapHomeInitialState()) {
    _initWithPermissionCheck();
  }

  /// Called on init and every time the app resumes (via the View lifecycle).
  Future<void> checkLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (isClosed) return;
      emit(MapHomeLocationDeniedState(isPermanent: true));
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (isClosed) return;

    if (permission == LocationPermission.denied) {
      emit(MapHomeLocationDeniedState(isPermanent: false));
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      emit(MapHomeLocationDeniedState(isPermanent: true));
      return;
    }

    // Permission granted — proceed normally if we were blocked
    if (state is MapHomeLocationDeniedState || state is MapHomeInitialState) {
      LocationHelper.getCurrentLocation().then((pos) => _cachedPosition = pos);
      _loadSpecializations();
    }
  }

  Future<void> _initWithPermissionCheck() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (isClosed) return;
      emit(MapHomeLocationDeniedState(isPermanent: true));
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (isClosed) return;

    if (permission == LocationPermission.denied) {
      emit(MapHomeLocationDeniedState(isPermanent: false));
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      emit(MapHomeLocationDeniedState(isPermanent: true));
      return;
    }

    // All good — normal startup
    LocationHelper.getCurrentLocation().then((pos) => _cachedPosition = pos);
    _loadSpecializations();
  }

  void _loadSpecializations() {
    final sharedCubit = sl<SharedSpecializationsCubit>();

    if (sharedCubit.state is SharedSpecializationsLoaded) {
      _applySpecializations(
        (sharedCubit.state as SharedSpecializationsLoaded).specializations,
      );
      return;
    }

    _specSub = sharedCubit.stream.listen((specState) {
      if (specState is SharedSpecializationsLoaded) {
        _applySpecializations(specState.specializations);
        _specSub?.cancel();
      }
    });

    if (sharedCubit.state is SharedSpecializationsInitial) {
      sharedCubit.getFamousSpecializations();
    }
  }

  void _applySpecializations(List<SpecialtyModel> specs) {
    if (isClosed) return;
    final currentState = state;
    if (currentState is MapHomeLoadedState) {
      emit(currentState.copyWith(specializations: specs));
    } else if (currentState is MapHomeInitialState) {
      emit(MapHomeLoadedState(specializations: specs));
    } else if (currentState is MapHomeLoadingState) {
      _pendingSpecializations = specs;
    }
  }

  Future<void> searchClinics({
    String? searchText,
    String? specializationId,
    double? userLat,
    double? userLng,
    bool? isNearest,
    int? radiusInKm,
    int? pageNumber,
    int? pageSize,
    bool clearSpecialization = false,
  }) async {
    final currentState = state;
    final isInitialLoad = currentState is MapHomeInitialState || (currentState is MapHomeLoadedState && currentState.clinics.isEmpty && currentState.query == null && currentState.specializationId == null);
    
    List<ClinicModel> currentClinics = [];
    List<SpecialtyModel> currentSpecializations = [];
    String? currentQuery;
    String? currentSpec;
    bool currentNearest = true;
    int currentRadius = 5;

    if (currentState is MapHomeLoadedState) {
      currentClinics = currentState.clinics;
      currentSpecializations = currentState.specializations;
      currentQuery = searchText ?? currentState.query;
      currentSpec = clearSpecialization ? null : (specializationId ?? currentState.specializationId);
      currentNearest = isNearest ?? currentState.isNearest;
      currentRadius = radiusInKm ?? currentState.radiusInKm;
    } else {
      currentQuery = searchText;
      currentSpec = specializationId;
      currentNearest = isNearest ?? true;
      currentRadius = radiusInKm ?? 5;
      final sharedState = sl<SharedSpecializationsCubit>().state;
      if (sharedState is SharedSpecializationsLoaded) {
        currentSpecializations = sharedState.specializations;
      }
    }

    if (state is MapHomeLoadedState) {
      _previousLoadedState = state as MapHomeLoadedState;
    }

    _debounce?.cancel();
    
    Future<void> performSearch() async {
      if (isClosed) return;
      emit(MapHomeLoadingState(clinics: currentClinics));

      // Use custom location from state > provided params > GPS
      double? lat = userLat;
      double? lng = userLng;
      if (lat == null || lng == null) {
        if (state is MapHomeLoadedState && (state as MapHomeLoadedState).hasCustomLocation) {
          lat = (state as MapHomeLoadedState).customLat;
          lng = (state as MapHomeLoadedState).customLng;
        } else {
          final position = _cachedPosition ?? await LocationHelper.getCurrentLocation();
          _cachedPosition = position;
          lat = position.latitude;
          lng = position.longitude;
        }
      }

      _searchCancelToken?.cancel('new search started');
      _searchCancelToken = CancelToken();

      final result = await _mapHomeRepo.searchClinics(
        searchText: currentQuery,
        specializationId: currentSpec,
        userLat: lat,
        userLng: lng,
        isNearest: currentNearest,
        radiusInKm: currentRadius,
        pageNumber: pageNumber,
        pageSize: pageSize,
        cancelToken: _searchCancelToken,
      );

      if (isClosed) return;

      if (_pendingSpecializations != null) {
        currentSpecializations = _pendingSpecializations!;
        _pendingSpecializations = null;
      }

      result.fold(
        onSuccess: (data) {
          if (isClosed) return;
          if (state is MapHomeLoadedState) {
            emit(
              (state as MapHomeLoadedState).copyWith(
                clinics: data.items,
                specializations: currentSpecializations,
                query: currentQuery,
                specializationId: currentSpec,
                isNearest: currentNearest,
                radiusInKm: currentRadius,
                currentPage: data.pageNumber,
                hasMore: data.hasNextPage,
              ),
            );
          } else {
            emit(
              MapHomeLoadedState(
                clinics: data.items,
                specializations: currentSpecializations,
                query: currentQuery,
                specializationId: currentSpec,
                isNearest: currentNearest,
                radiusInKm: currentRadius,
                currentPage: data.pageNumber,
                hasMore: data.hasNextPage,
              ),
            );
          }
        },
        onFailure: (failure) {
          if (isClosed) return;
          if (failure is! CancelFailure) {
            emit(MapHomeErrorState(failure.userMessage, clinics: currentClinics));
          }
        },
      );
      _previousLoadedState = null;
    }

    if (isInitialLoad) {
      await performSearch();
    } else {
      _debounce = Timer(const Duration(milliseconds: 300), () async {
        await performSearch();
      });
    }
  }

  Future<void> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    final currentState = state;
    if (currentState is! MapHomeLoadedState) return;

    _routeCancelToken?.cancel('new route requested');
    _routeCancelToken = CancelToken();

    // Use backend endpoint to get the route (which wraps OSRM data internally)
    final result = await _mapHomeRepo.getRoute(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
      cancelToken: _routeCancelToken,
    );

    if (isClosed) return;

    result.fold(
      onSuccess: (data) {
        if (isClosed) return;
        emit(currentState.copyWith(route: data));
      },
      onFailure: (failure) {
        // Silently fail for route — don't break the UI
        debugPrint('Route fetch failed (Backend): ${failure.message}');
      },
    );
  }

  void selectClinic(ClinicModel clinic) async {
    final currentState = state;
    if (currentState is MapHomeLoadedState) {
      if (isClosed) return;
      emit(
        currentState.copyWith(
          selectedClinic: clinic,
          clearSelectedClinic: false,
          isNavigating: false,
          lastRouteLat:
              null, // Reset last fetch location to force initial route
          lastRouteLng: null,
        ),
      );

      // Automatically get route to selected clinic
      double startLat;
      double startLng;
      if (currentState.hasCustomLocation) {
        startLat = currentState.customLat!;
        startLng = currentState.customLng!;
      } else {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
        startLat = position.latitude;
        startLng = position.longitude;
        _cachedPosition = LatLng(position.latitude, position.longitude);
        if (isClosed) return;
        if (state is MapHomeLoadedState) {
          emit(
            (state as MapHomeLoadedState).copyWith(
              currentUserLat: startLat,
              currentUserLng: startLng,
              currentUserHeading: position.heading,
            ),
          );
        }
      }

      await getRoute(
        startLat: startLat,
        startLng: startLng,
        endLat: clinic.lat ?? 0.0,
        endLng: clinic.lng ?? 0.0,
      );

      // Update state with fetch location
      if (isClosed) return;
      if (state is MapHomeLoadedState) {
        emit(
          (state as MapHomeLoadedState).copyWith(
            lastRouteLat: startLat,
            lastRouteLng: startLng,
          ),
        );
      }

      // Start live navigation updates every 5 seconds
      _startLiveNavigation(clinic);
    }
  }

  void _startLiveNavigation(ClinicModel clinic) {
    _isLiveNavigating = true;
    _navigatingClinic = clinic;
  }

  Future<void> checkLiveLocation() async {
    if (!_isLiveNavigating || _navigatingClinic == null) return;

    final currentState = state;
    if (currentState is! MapHomeLoadedState ||
        currentState.selectedClinic?.id != _navigatingClinic!.id) {
      _isLiveNavigating = false;
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    if (isClosed) return;

    // Check if user moved far enough from last fetch point (e.g. > 20 meters)
    double distance = 999; // Default to large if no last point
    if (currentState.lastRouteLat != null &&
        currentState.lastRouteLng != null) {
      distance = Geolocator.distanceBetween(
        currentState.lastRouteLat!,
        currentState.lastRouteLng!,
        position.latitude,
        position.longitude,
      );
    }

    _cachedPosition = LatLng(position.latitude, position.longitude);

    if (distance > 20) {
      debugPrint('📍 [LiveNav] Moved ${distance.toInt()}m. Updating route...');
      await getRoute(
        startLat: position.latitude,
        startLng: position.longitude,
        endLat: _navigatingClinic!.lat ?? 0.0,
        endLng: _navigatingClinic!.lng ?? 0.0,
      );

      if (isClosed) return;
      if (state is MapHomeLoadedState) {
        emit(
          (state as MapHomeLoadedState).copyWith(
            currentUserLat: position.latitude,
            currentUserLng: position.longitude,
            currentUserHeading: position.heading,
            lastRouteLat: position.latitude,
            lastRouteLng: position.longitude,
          ),
        );
      }
    } else {
      debugPrint(
        '📍 [LiveNav] Minor movement (${distance.toInt()}m). Skipping route update.',
      );
      if (isClosed) return;
      emit(
        currentState.copyWith(
          currentUserLat: position.latitude,
          currentUserLng: position.longitude,
          currentUserHeading: position.heading,
        ),
      );
    }
  }

  /// Set a custom search location (user-picked on map)
  void setCustomLocation(double lat, double lng) {
    final currentState = state;
    if (currentState is MapHomeLoadedState) {
      if (isClosed) return;
      emit(currentState.copyWith(customLat: lat, customLng: lng));
    }
  }

  /// Deselect the current clinic and return to list view
  void deselectClinic() {
    final currentState = state;
    if (currentState is MapHomeLoadedState) {
      if (isClosed) return;
      emit(currentState.copyWith(clearSelectedClinic: true, route: null));
    }
  }

  /// Reset to current GPS location
  void clearCustomLocation() {
    final currentState = state;
    if (currentState is MapHomeLoadedState) {
      if (isClosed) return;
      emit(currentState.clearCustomLocation());
    }
  }

  void cancelSearch() {
    _debounce?.cancel();
    _searchCancelToken?.cancel('user cancelled');
    _searchCancelToken = null;

    if (isClosed) return;

    if (_previousLoadedState != null) {
      emit(_previousLoadedState!);
      _previousLoadedState = null;
    } else {
      emit(MapHomeInitialState());
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! MapHomeLoadedState) return;
    if (!currentState.hasMore || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;

    double? lat;
    double? lng;
    if (currentState.hasCustomLocation) {
      lat = currentState.customLat;
      lng = currentState.customLng;
    } else if (currentState.currentUserLat != null) {
      lat = currentState.currentUserLat;
      lng = currentState.currentUserLng;
    } else {
      final position = _cachedPosition ?? await LocationHelper.getCurrentLocation();
      _cachedPosition = position;
      lat = position.latitude;
      lng = position.longitude;
    }

    final result = await _mapHomeRepo.searchClinics(
      searchText: currentState.query,
      specializationId: currentState.specializationId,
      userLat: lat,
      userLng: lng,
      isNearest: currentState.isNearest,
      radiusInKm: currentState.radiusInKm,
      pageNumber: nextPage,
      cancelToken: _searchCancelToken,
    );

    if (isClosed) return;

    result.fold(
      onSuccess: (data) {
        if (isClosed) return;
        if (state is MapHomeLoadedState) {
          emit(
            (state as MapHomeLoadedState).copyWith(
              clinics: [...(state as MapHomeLoadedState).clinics, ...data.items],
              currentPage: data.pageNumber,
              hasMore: data.hasNextPage,
              isLoadingMore: false,
            ),
          );
        }
      },
      onFailure: (failure) {
        if (isClosed) return;
        if (state is MapHomeLoadedState) {
          emit((state as MapHomeLoadedState).copyWith(isLoadingMore: false));
        }
      },
    );
  }

  void startNavigation() {
    final currentState = state;
    if (currentState is MapHomeLoadedState && currentState.route != null) {
      if (isClosed) return;
      emit(currentState.copyWith(isNavigating: true));
    }
  }

  void stopNavigation() {
    _isLiveNavigating = false;
    _navigatingClinic = null;
    final currentState = state;
    if (currentState is MapHomeLoadedState) {
      if (isClosed) return;
      emit(currentState.copyWith(isNavigating: false));
    }
  }

  @override
  Future<void> close() {
    _isLiveNavigating = false;
    _specSub?.cancel();
    _debounce?.cancel();
    _searchCancelToken?.cancel();
    _routeCancelToken?.cancel();
    return super.close();
  }
}
