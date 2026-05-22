import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import '../data/repo/booking_repo.dart';
import '../data/model/create_appointment_request.dart';
import 'booking_states.dart';
import 'package:easy_localization/easy_localization.dart';

class BookingCubit extends Cubit<BookingStates> {
  final BookingRepo bookingRepo;
  final DoctorModel doctor;
  final String clinicId;

  BookingStateUpdated _currentState;

  BookingCubit({
    required this.bookingRepo,
    required this.doctor,
    required this.clinicId,
  })  : _currentState = BookingStateUpdated(doctor: doctor, clinicId: clinicId),
        super(BookingInitial()) {
    _emitUpdate();
  }

  // ─────────────── State Emission ───────────────

  void _emitUpdate() {
    emit(_currentState);
  }

  // ─────────────── Getters ───────────────

  BookingStep get currentStep => _currentState.currentStep;
  DateTime? get selectedDate => _currentState.selectedDate;
  TimeSlotModel? get selectedTime => _currentState.selectedTime;

  // ─────────────── Step Navigation ───────────────

  void nextStep() {
    final steps = BookingStep.values;
    final currentIndex = steps.indexOf(_currentState.currentStep);
    if (currentIndex < steps.length - 1) {
      _currentState = _currentState.copyWith(currentStep: steps[currentIndex + 1]);
      _emitUpdate();
    }
  }

  void previousStep() {
    final steps = BookingStep.values;
    final currentIndex = steps.indexOf(_currentState.currentStep);
    if (currentIndex > 0) {
      _currentState = _currentState.copyWith(currentStep: steps[currentIndex - 1]);
      _emitUpdate();
    }
  }

  void goToStep(BookingStep step) {
    _currentState = _currentState.copyWith(currentStep: step);
    _emitUpdate();
  }

  // ─────────────── Data Selection ───────────────

  Future<void> selectDate(DateTime date) async {
    _currentState = _currentState.copyWith(
      selectedDate: date,
      selectedTime: null,
      availableSlots: null,
    );
    _emitUpdate();
    await fetchAvailableSlots(date);
  }

  Future<void> fetchAvailableSlots(DateTime date) async {
    emit(BookingSlotsLoading());
    final result = await bookingRepo.getAvailableSlots(
      doctorId: doctor.id,
      clinicId: clinicId,
      date: date,
    );

    result.fold(
      onSuccess: (data) {
        _currentState = _currentState.copyWith(availableSlots: data.slots);
        _emitUpdate();
      },
      onFailure: (failure) {
        emit(BookingSlotsError(failure.message));
        _emitUpdate();
      },
    );
  }

  void selectTime(TimeSlotModel time) {
    _currentState = _currentState.copyWith(selectedTime: time);
    _emitUpdate();
  }

  void updatePatientInfo({
    String? name,
    String? phone,
    String? age,
    int? gender,
    int? appointmentType,
    String? complaint,
    String? notes,
  }) {
    _currentState = _currentState.copyWith(
      patientName: name,
      patientPhone: phone,
      patientAge: age,
      patientGender: gender,
      appointmentType: appointmentType,
      complaint: complaint,
      notes: notes,
    );
    _emitUpdate();
  }

  // ─────────────── Confirm Booking ───────────────

  Future<bool> confirmBooking() async {
    if (_currentState.selectedDate == null ||
        _currentState.selectedTime == null ||
        _currentState.patientName.isEmpty ||
        _currentState.patientPhone.isEmpty ||
        _currentState.patientAge.isEmpty ||
        _currentState.complaint.isEmpty) {
      emit(BookingErrorState('Please fill all required fields'));
      _emitUpdate();
      return false;
    }

    emit(BookingSubmitting());

    final request = CreateAppointmentRequest(
      doctorId: doctor.id,
      clinicId: clinicId,
      appointmentDate: _currentState.selectedDate!,
      startTime: DateFormat('HH:mm').format(_currentState.selectedTime!.startTime),
      endTime: DateFormat('HH:mm').format(_currentState.selectedTime!.endTime),
      appointmentType: _currentState.appointmentType,
      patientFullName: _currentState.patientName,
      patientPhoneNumber: _currentState.patientPhone,
      patientAge: _currentState.patientAge,
      patientGender: _currentState.patientGender,
      complaint: _currentState.complaint,
      chronicDiseases: _currentState.notes.isEmpty ? null : _currentState.notes,
    );

    final result = await bookingRepo.createAppointment(request);

    return result.fold(
      onSuccess: (data) {
        _currentState = _currentState.copyWith(
          currentStep: BookingStep.success,
          bookingRef: data is Map ? data['id']?.toString() : null,
        );
        _emitUpdate();
        return true;
      },
      onFailure: (failure) {
        emit(BookingErrorState(failure.message));
        _emitUpdate();
        return false;
      },
    );
  }
}
