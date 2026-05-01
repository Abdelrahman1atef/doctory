import 'package:doctory/core/common/models/clinic_model.dart';
import 'package:doctory/features/map_home/data/model/route_model.dart';

abstract class MapHomeStates {}

class MapHomeInitialState extends MapHomeStates {}

class MapHomeLoadingState extends MapHomeStates {
  final List<ClinicModel> clinics;
  MapHomeLoadingState({this.clinics = const []});
}

class MapHomeLoadedState extends MapHomeStates {
  final List<ClinicModel> clinics;
  final ClinicModel? selectedClinic;
  final RouteModel? route;
  final String? query;
  final String? specializationId;
  final bool isNearest;
  final int radiusInKm;
  final double? customLat;
  final double? customLng;

  MapHomeLoadedState({
    this.clinics = const [],
    this.selectedClinic,
    this.route,
    this.query,
    this.specializationId,
    this.isNearest = false,
    this.radiusInKm = 5,
    this.customLat,
    this.customLng,
  });

  /// Whether user has set a custom search location
  bool get hasCustomLocation => customLat != null && customLng != null;

  MapHomeLoadedState copyWith({
    List<ClinicModel>? clinics,
    ClinicModel? selectedClinic,
    RouteModel? route,
    String? query,
    String? specializationId,
    bool? isNearest,
    int? radiusInKm,
    double? customLat,
    double? customLng,
  }) {
    return MapHomeLoadedState(
      clinics: clinics ?? this.clinics,
      selectedClinic: selectedClinic ?? this.selectedClinic,
      route: route ?? this.route,
      query: query ?? this.query,
      specializationId: specializationId ?? this.specializationId,
      isNearest: isNearest ?? this.isNearest,
      radiusInKm: radiusInKm ?? this.radiusInKm,
      customLat: customLat ?? this.customLat,
      customLng: customLng ?? this.customLng,
    );
  }

  /// Create copy that resets custom location to null
  MapHomeLoadedState clearCustomLocation() {
    return MapHomeLoadedState(
      clinics: clinics,
      selectedClinic: selectedClinic,
      route: route,
      query: query,
      specializationId: specializationId,
      isNearest: isNearest,
      radiusInKm: radiusInKm,
      customLat: null,
      customLng: null,
    );
  }
}

class MapHomeErrorState extends MapHomeStates {
  final String message;
  final List<ClinicModel> clinics;
  MapHomeErrorState(this.message, {this.clinics = const []});
}
