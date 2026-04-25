import 'package:doctory/features/search_results/data/model/hospital_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class SearchStates {}

class SearchInitialState extends SearchStates {}

class SearchLoadingState extends SearchStates {}

class SearchSuccessState extends SearchStates {
  final List<HospitalModel> hospitals;
  final int? selectedIndex;
  final List<LatLng>? routePoints;

  SearchSuccessState({
    required this.hospitals,
    this.selectedIndex,
    this.routePoints,
  });

  SearchSuccessState copyWith({
    List<HospitalModel>? hospitals,
    int? selectedIndex,
    List<LatLng>? routePoints,
  }) {
    return SearchSuccessState(
      hospitals: hospitals ?? this.hospitals,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      routePoints: routePoints ?? this.routePoints,
    );
  }
}

class SearchErrorState extends SearchStates {
  final String message;
  SearchErrorState(this.message);
}
