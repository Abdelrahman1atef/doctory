import 'package:doctory/core/common/functions/location_helper.dart';
import 'package:doctory/features/search_results/cubit/search_states.dart';
import 'package:doctory/features/search_results/data/model/hospital_model.dart';
import 'package:doctory/features/search_results/data/repo/search_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchCubit extends Cubit<SearchStates> {
  final SearchRepo _searchRepo;

  SearchCubit(this._searchRepo) : super(SearchInitialState());

  /// Search hospitals by coordinates and optional query text.
  void searchHospitals({
    required double lat,
    required double lng,
    String? query,
  }) async {
    emit(SearchLoadingState());

    final result = await _searchRepo.searchHospitals(
      lat: lat,
      lng: lng,
      query: query,
    );

    result.fold(
      onSuccess: (hospitals) async {
        // Use compute to sort results off the main thread
        final sortedHospitals = await compute(_sortHospitals, hospitals);
        
        emit(
          SearchSuccessState(
            hospitals: sortedHospitals,
            selectedIndex: sortedHospitals.isNotEmpty ? 0 : null,
          ),
        );
      },
      onFailure: (failure) {
        emit(SearchErrorState(failure.message));
      },
    );
  }

  /// Top-level or static function for isolate sorting
  static List<HospitalModel> _sortHospitals(List<HospitalModel> list) {
    list.sort((a, b) => a.distance.compareTo(b.distance));
    return list;
  }

  /// Load hospitals from pre-fetched data (e.g. passed from home search).
  void loadFromData(List<HospitalModel> hospitals) {
    hospitals.sort((a, b) => a.distance.compareTo(b.distance));
    emit(
      SearchSuccessState(
        hospitals: hospitals,
        selectedIndex: hospitals.isNotEmpty ? 0 : null,
      ),
    );
  }

  /// Gets user location first, then performs search.
  void getUserLocationAndSearch({String? query}) async {
    emit(SearchLoadingState());
    
    final LatLng location = await LocationHelper.getCurrentLocation();
    
    // Call actual search
    searchHospitals(
      lat: location.latitude, 
      lng: location.longitude, 
      query: query,
    );
  }

  /// Select a hospital by index (when user taps on a marker or list item).
  void selectHospital(int index) async {
    final currentState = state;
    if (currentState is SearchSuccessState) {
      // Update selected index immediately for UI responsiveness
      emit(currentState.copyWith(selectedIndex: index, routePoints: []));

      // Fetch route to the selected hospital
      final hospital = currentState.hospitals[index];
      final userLocation = await LocationHelper.getCurrentLocation();
      
      final points = await LocationHelper.getRoutePoints(
        startLat: userLocation.latitude,
        startLng: userLocation.longitude,
        endLat: hospital.lat,
        endLng: hospital.lng,
      );

      // Update state with route points
      if (state is SearchSuccessState) {
        emit((state as SearchSuccessState).copyWith(routePoints: points));
      }
    }
  }
}
