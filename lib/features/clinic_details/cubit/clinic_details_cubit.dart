import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/features/clinic_details/data/data_source/clinic_details_mock_data.dart';
import 'clinic_details_states.dart';

class ClinicDetailsCubit extends Cubit<ClinicDetailsStates> {
  ClinicDetailsCubit() : super(ClinicDetailsInitial());

  void loadClinicDetails(String id) async {
    emit(ClinicDetailsLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final clinic = ClinicDetailsMockData.getClinicDetails(id);
      emit(ClinicDetailsLoaded(clinic));
    } catch (e) {
      emit(ClinicDetailsError('Failed to load clinic details'));
    }
  }
}
