import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/error/failures.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/features/clinic/cubit/clinic_availability_state.dart';
import 'package:doctory/features/clinic/data/model/availability_dto.dart';
import 'package:doctory/features/clinic/data/repo/clinic_dashboard_repo.dart';

class ClinicAvailabilityCubit extends Cubit<ClinicAvailabilityState> {
  final ClinicDashboardRepo _repo;
  List<AvailabilityDto> currentAvailability = [];
  String? _currentDoctorId;

  ClinicAvailabilityCubit(this._repo) : super(ClinicAvailabilityInitial());

  String get _clinicId => UserSession.clinicId ?? '';

  Future<void> loadAvailability(String doctorId) async {
    _currentDoctorId = doctorId;
    final clinicId = _clinicId;
    if (clinicId.isEmpty) {
      emit(ClinicAvailabilityError('Clinic ID not found.'));
      return;
    }
    if (doctorId.isEmpty) {
      emit(ClinicAvailabilityError('Doctor ID not found.'));
      return;
    }

    emit(ClinicAvailabilityLoading());
    final result = await _repo.getAvailability(doctorId, clinicId);
    
    result.fold(
      onSuccess: (list) {
        currentAvailability = list;
        emit(ClinicAvailabilitySuccess(list));
      },
      onFailure: (failure) {
        emit(ClinicAvailabilityError(failure.userMessage));
      },
    );
  }

  /// Re-fetches the windows of the doctor loaded last (retry / after writes).
  Future<void> reload() => loadAvailability(_currentDoctorId ?? '');

  Future<void> addAvailability(AvailabilityDto availability) async {
    emit(ClinicAvailabilitySubmitLoading());
    final result = await _repo.createAvailability(availability);

    result.fold(
      onSuccess: (_) {
        emit(ClinicAvailabilitySubmitSuccess());
        reload();
      },
      onFailure: (failure) {
        emit(ClinicAvailabilitySubmitError(failure.userMessage));
      },
    );
  }

  Future<void> updateAvailability(String id, AvailabilityDto availability) async {
    emit(ClinicAvailabilitySubmitLoading());
    final result = await _repo.updateAvailability(id, availability);

    result.fold(
      onSuccess: (_) {
        emit(ClinicAvailabilitySubmitSuccess());
        reload();
      },
      onFailure: (failure) {
        emit(ClinicAvailabilitySubmitError(failure.userMessage));
      },
    );
  }

  Future<void> deleteAvailability(String id) async {
    emit(ClinicAvailabilitySubmitLoading());
    final result = await _repo.deleteAvailability(id);

    result.fold(
      onSuccess: (_) {
        emit(ClinicAvailabilitySubmitSuccess());
        reload();
      },
      onFailure: (failure) {
        emit(ClinicAvailabilitySubmitError(failure.userMessage));
      },
    );
  }
}
