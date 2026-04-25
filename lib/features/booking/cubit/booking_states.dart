import 'package:doctory/core/common/models/shared_models.dart';

abstract class BookingStates {}

class BookingInitial extends BookingStates {}

class BookingStateUpdated extends BookingStates {
  final DoctorModel doctor;
  final DateTime? selectedDate;
  final TimeSlotModel? selectedTime;
  final String patientName;
  final String patientPhone;
  final String notes;

  BookingStateUpdated({
    required this.doctor,
    this.selectedDate,
    this.selectedTime,
    this.patientName = '',
    this.patientPhone = '',
    this.notes = '',
  });
}

class BookingSubmitting extends BookingStates {}

class BookingSuccessState extends BookingStates {}

class BookingErrorState extends BookingStates {
  final String message;
  BookingErrorState(this.message);
}
