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

  String get _clinicId => UserSession.clinicId ?? '';

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
        // 404 means the clinic has not configured booking yet — not an error,
        // the form opens in create mode and the first save uses POST.
        if (failure is NotFoundFailure) {
          currentConfig = null;
          emit(ClinicBookingConfigEmpty());
        } else {
          emit(ClinicBookingConfigError(failure.userMessage));
        }
      },
    );
  }

  Future<void> submitConfig(BookingConfigDto config) async {
    final clinicId = _clinicId;
    if (clinicId.isEmpty) return;

    final isFirstSetup = !isEditMode;
    emit(ClinicBookingConfigSubmitLoading());
    final result = isFirstSetup
        ? await _repo.createBookingConfig(clinicId, config)
        : await _repo.updateBookingConfig(clinicId, config);

    result.fold(
      onSuccess: (updatedConfig) {
        currentConfig = updatedConfig;
        emit(ClinicBookingConfigSubmitSuccess(updatedConfig, isFirstSetup: isFirstSetup));
      },
      onFailure: (failure) {
        emit(ClinicBookingConfigSubmitError(failure.userMessage));
      },
    );
  }
}
