import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/features/doctor_details/data/data_source/doctor_details_mock_data.dart';
import 'doctor_details_states.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsStates> {
  DoctorDetailsCubit() : super(DoctorDetailsInitial());

  void loadDoctorDetails(String id) async {
    emit(DoctorDetailsLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final doctor = DoctorDetailsMockData.getDoctorDetails(id);
      emit(DoctorDetailsLoaded(doctor));
    } catch (e) {
      emit(DoctorDetailsError('Failed to load doctor details'));
    }
  }
}
