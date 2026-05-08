import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'booking_states.dart';

class BookingCubit extends Cubit<BookingStates> {
  final DoctorModel doctor;

  BookingStep _currentStep = BookingStep.selectDate;
  DateTime? _selectedDate;
  TimeSlotModel? _selectedTime;
  String _patientName = '';
  String _patientPhone = '';
  String _notes = '';
  String? _bookingRef;

  BookingCubit({required this.doctor}) : super(BookingInitial()) {
    _emitUpdate();
  }

  // ─────────────── Getters ───────────────

  BookingStep get currentStep => _currentStep;
  DateTime? get selectedDate => _selectedDate;
  TimeSlotModel? get selectedTime => _selectedTime;

  // ─────────────── State Emission ───────────────

  void _emitUpdate() {
    emit(
      BookingStateUpdated(
        doctor: doctor,
        currentStep: _currentStep,
        selectedDate: _selectedDate,
        selectedTime: _selectedTime,
        patientName: _patientName,
        patientPhone: _patientPhone,
        notes: _notes,
        bookingRef: _bookingRef,
      ),
    );
  }

  // ─────────────── Step Navigation ───────────────

  void nextStep() {
    final steps = BookingStep.values;
    final currentIndex = steps.indexOf(_currentStep);
    if (currentIndex < steps.length - 1) {
      _currentStep = steps[currentIndex + 1];
      _emitUpdate();
    }
  }

  void previousStep() {
    final steps = BookingStep.values;
    final currentIndex = steps.indexOf(_currentStep);
    if (currentIndex > 0) {
      _currentStep = steps[currentIndex - 1];
      _emitUpdate();
    }
  }

  void goToStep(BookingStep step) {
    _currentStep = step;
    _emitUpdate();
  }

  // ─────────────── Data Selection ───────────────

  void selectDate(DateTime date) {
    _selectedDate = date;
    _selectedTime = null; // Reset time when date changes
    _emitUpdate();
  }

  void selectTime(TimeSlotModel time) {
    _selectedTime = time;
    _emitUpdate();
  }

  void updatePatientInfo({String? name, String? phone, String? notes}) {
    if (name != null) _patientName = name;
    if (phone != null) _patientPhone = phone;
    if (notes != null) _notes = notes;
    _emitUpdate();
  }

  // ─────────────── Confirm Booking ───────────────

  Future<bool> confirmBooking() async {
    if (_selectedDate == null ||
        _selectedTime == null ||
        _patientName.isEmpty ||
        _patientPhone.isEmpty) {
      emit(BookingErrorState('Please fill all required fields'));
      _emitUpdate();
      return false;
    }

    emit(BookingSubmitting());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      // Generate a mock booking reference
      _bookingRef = 'BK-${Random().nextInt(900000) + 100000}';
      _currentStep = BookingStep.success;
      _emitUpdate();
      return true;
    } catch (e) {
      emit(BookingErrorState('Failed to confirm booking'));
      _emitUpdate();
      return false;
    }
  }
}
