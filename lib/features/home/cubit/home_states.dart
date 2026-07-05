import 'package:doctory/core/common/models/shared_models.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeLoadingState extends HomeStates {}

class HomeSuccessState extends HomeStates {
  final List<SpecialtyModel> specialties;
  final List<DoctorModel> recommendedDoctors;
  final List<ClinicModel> featuredClinics;
  final int unreadCount;

  HomeSuccessState({
    required this.specialties,
    required this.recommendedDoctors,
    required this.featuredClinics,
    this.unreadCount = 0,
  });
}

class HomeErrorState extends HomeStates {
  final String message;
  HomeErrorState(this.message);
}

// Search States
class SearchLoadingState extends HomeStates {}

class SearchSuccessState extends HomeStates {
  final List<DoctorModel> doctors;
  final List<ClinicModel> clinics;

  SearchSuccessState({required this.doctors, required this.clinics});
}

class SearchErrorState extends HomeStates {
  final String message;
  SearchErrorState(this.message);
}
