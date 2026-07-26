import 'package:flutter_bloc/flutter_bloc.dart';
import 'doctor_details_states.dart';
import '../data/data_source/doctor_details_remote_data_source.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsStates> {
  final DoctorDetailsRemoteDataSource remoteDataSource;

  DoctorDetailsCubit({required this.remoteDataSource})
      : super(DoctorDetailsInitial());

  void loadDoctorDetails(String id) async {
    emit(DoctorDetailsLoading());
    final result = await remoteDataSource.getDoctorDetails(id);
    result.fold(
      onSuccess: (doctor) => emit(DoctorDetailsLoaded(doctor)),
      onFailure: (failure) => emit(DoctorDetailsError(failure.message)),
    );
  }
}
