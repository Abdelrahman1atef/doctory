import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/core/error/failures.dart';
import 'package:doctory/features/clinic/cubit/clinic_booking_config_state.dart';
import 'package:doctory/features/clinic/data/model/booking_config_dto.dart';
import 'package:doctory/features/clinic/data/repo/clinic_dashboard_repo.dart';

class ClinicBookingConfigCubit extends Cubit<ClinicBookingConfigState> {
  final ClinicDashboardRepo _repo;
  BookingConfigDto? currentConfig;
  bool get isEditMode => currentConfig != null;

  ClinicBookingConfigCubit(this._repo) : super(ClinicBookingConfigInitial());

  String get _clinicId {
    return UserSession.userModel?['clinicId']?.toString() ?? '';
  }

  Future<void> loadConfig() async {
    final clinicId = _clinicId;
    if (clinicId.isEmpty) {
      emit(ClinicBookingConfigError('Clinic ID not found.'));
      return;
    }

    emit(ClinicBookingConfigLoading());
    final result = await _repo.getBookingConfig(clinicId);
    
    result.fold(
      onSuccess: (config) {
        currentConfig = config;
        emit(ClinicBookingConfigSuccess(config));
      },
      onFailure: (failure) {
        // If 404 / NotFoundFailure, it means no config exists yet. We don't consider it a fatal error, 
        // we just show the form in "create" mode.
        // The backend returns 404 if not found.
        if (failure is NotFoundFailure || failure.code == '404' || failure.userMessage.toLowerCase().contains('not found')) {
          currentConfig = null;
          emit(ClinicBookingConfigSuccess(BookingConfigDto.mock)); // Just returning a mock to initialize the form
        } else {
          emit(ClinicBookingConfigError(failure.userMessage));
        }
      },
    );
  }

  Future<void> submitConfig(BookingConfigDto config) async {
    final clinicId = _clinicId;
    if (clinicId.isEmpty) return;

    emit(ClinicBookingConfigSubmitLoading());
    final result = isEditMode
        ? await _repo.updateBookingConfig(clinicId, config)
        : await _repo.createBookingConfig(clinicId, config);

    result.fold(
      onSuccess: (updatedConfig) {
        currentConfig = updatedConfig;
        emit(ClinicBookingConfigSubmitSuccess(updatedConfig));
        // Reset back to success state to re-render the view if needed
        emit(ClinicBookingConfigSuccess(updatedConfig));
      },
      onFailure: (failure) {
        emit(ClinicBookingConfigSubmitError(failure.userMessage));
      },
    );
  }
}
