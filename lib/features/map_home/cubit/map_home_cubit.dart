import 'package:doctory/core/common/models/clinic_model.dart';
import 'package:doctory/core/common/functions/location_helper.dart';
import 'package:doctory/core/error/failures.dart';
import 'package:doctory/features/map_home/cubit/map_home_states.dart';
import 'package:doctory/features/map_home/data/repo/map_home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapHomeCubit extends Cubit<MapHomeStates> {
  final MapHomeRepo _mapHomeRepo;

  MapHomeCubit(this._mapHomeRepo) : super(MapHomeInitialState());

  Future<void> searchClinics({
    String? searchText,
    String? specializationId,
    double? userLat,
    double? userLng,
    bool? isNearest,
    int? radiusInKm,
    int? pageNumber,
    int? pageSize,
  }) async {
    final currentState = state;
    List<ClinicModel> currentClinics = [];
    String? currentQuery;
    String? currentSpec;
    bool currentNearest = true;
    int currentRadius = 5;

    if (currentState is MapHomeLoadedState) {
      currentClinics = currentState.clinics;
      currentQuery = searchText ?? currentState.query;
      currentSpec = specializationId ?? currentState.specializationId;
      currentNearest = isNearest ?? currentState.isNearest;
      currentRadius = radiusInKm ?? currentState.radiusInKm;
    } else {
      currentQuery = searchText;
      currentSpec = specializationId;
      currentNearest = isNearest ?? true;
      currentRadius = radiusInKm ?? 5;
    }

    emit(MapHomeLoadingState(clinics: currentClinics));

    // Get current location if not provided
    double? lat = userLat;
    double? lng = userLng;
    if (lat == null || lng == null) {
      final position = await LocationHelper.getCurrentLocation();
      lat = position.latitude;
      lng = position.longitude;
    }

    final result = await _mapHomeRepo.searchClinics(
      searchText: currentQuery,
      specializationId: currentSpec,
      userLat: lat,
      userLng: lng,
      isNearest: currentNearest,
      radiusInKm: currentRadius,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );

    result.fold(
      onSuccess: (data) {
        if (state is MapHomeLoadedState) {
          emit((state as MapHomeLoadedState).copyWith(
            clinics: data.items,
            query: currentQuery,
            specializationId: currentSpec,
            isNearest: currentNearest,
            radiusInKm: currentRadius,
          ));
        } else {
          emit(MapHomeLoadedState(
            clinics: data.items,
            query: currentQuery,
            specializationId: currentSpec,
            isNearest: currentNearest,
            radiusInKm: currentRadius,
          ));
        }
      },
      onFailure: (failure) => emit(MapHomeErrorState(
        failure.userMessage,
        clinics: currentClinics,
      )),
    );
  }

  Future<void> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    final currentState = state;
    if (currentState is! MapHomeLoadedState) return;

    emit(MapHomeLoadingState(clinics: currentState.clinics));

    final result = await _mapHomeRepo.getRoute(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );

    result.fold(
      onSuccess: (data) => emit(currentState.copyWith(route: data)),
      onFailure: (failure) => emit(MapHomeErrorState(
        failure.userMessage,
        clinics: currentState.clinics,
      )),
    );
  }

  void selectClinic(dynamic clinic) {
    if (state is MapHomeLoadedState) {
      emit((state as MapHomeLoadedState).copyWith(selectedClinic: clinic));
    }
  }
}
