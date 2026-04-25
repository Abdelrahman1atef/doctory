import 'package:doctory/core/common/models/shared_models.dart';

abstract class MapHomeStates {}

class MapHomeInitial extends MapHomeStates {}

class MapHomeLoading extends MapHomeStates {}

class MapHomeLoaded extends MapHomeStates {
  final List<ClinicModel> clinics;
  final ClinicModel? selectedClinic;
  final List<dynamic> routePoints;
  final String? query;

  MapHomeLoaded({
    required this.clinics,
    this.selectedClinic,
    this.routePoints = const [],
    this.query,
  });

  MapHomeLoaded copyWith({
    List<ClinicModel>? clinics,
    ClinicModel? selectedClinic,
    List<dynamic>? routePoints,
    String? query,
  }) {
    return MapHomeLoaded(
      clinics: clinics ?? this.clinics,
      selectedClinic: selectedClinic ?? this.selectedClinic,
      routePoints: routePoints ?? this.routePoints,
      query: query ?? this.query,
    );
  }
}

class MapHomeError extends MapHomeStates {
  final String message;
  MapHomeError(this.message);
}
