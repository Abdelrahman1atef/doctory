import 'package:doctory/core/common/models/clinic_model.dart';
import 'package:doctory/features/clinic_details/data/data_source/clinic_details_remote_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'clinic_details_states.dart';

class ClinicDetailsCubit extends Cubit<ClinicDetailsStates> {
  final ClinicDetailsRemoteDataSource _remoteDataSource;

  ClinicDetailsCubit({required ClinicDetailsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource,
        super(ClinicDetailsInitial());

  void loadClinicDetails(ClinicModel clinic) async {
    if (!clinic.isRegistered) {
      emit(ClinicDetailsLoaded(clinic));
      return;
    }

    emit(ClinicDetailsLoading());
    final result = await _remoteDataSource.getClinicDetails(clinic.id);
    result.fold(
      onSuccess: (detailedClinic) =>
          emit(ClinicDetailsLoaded(detailedClinic)),
      onFailure: (failure) => emit(ClinicDetailsError(failure.message)),
    );
  }
}
