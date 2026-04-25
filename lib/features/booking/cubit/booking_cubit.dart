import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'booking_states.dart';

class BookingCubit extends Cubit<BookingStates> {
  final DoctorModel doctor;

  DateTime? _selectedDate;
  TimeSlotModel? _selectedTime;
  String _patientName = '';
  String _patientPhone = '';
  String _notes = '';

  BookingCubit({required this.doctor}) : super(BookingInitial()) {
    _emitUpdate();
  }

  void _emitUpdate() {
    emit(
      BookingStateUpdated(
        doctor: doctor,
        selectedDate: _selectedDate,
        selectedTime: _selectedTime,
        patientName: _patientName,
        patientPhone: _patientPhone,
        notes: _notes,
      ),
    );
  }

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
      emit(BookingSuccessState());
      return true;
    } catch (e) {
      emit(BookingErrorState('Failed to confirm booking'));
      _emitUpdate();
      return false;
    }
  }
}
