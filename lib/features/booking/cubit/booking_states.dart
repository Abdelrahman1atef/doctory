import 'package:doctory/core/common/models/shared_models.dart';

/// The steps of the booking flow
enum BookingStep { selectDate, selectTime, confirm, success }

abstract class BookingStates {}

class BookingInitial extends BookingStates {}

class BookingStateUpdated extends BookingStates {
  final DoctorModel doctor;
  final BookingStep currentStep;
  final DateTime? selectedDate;
  final TimeSlotModel? selectedTime;
  final String patientName;
  final String patientPhone;
  final String notes;
  final String? bookingRef;

  BookingStateUpdated({
    required this.doctor,
    this.currentStep = BookingStep.selectDate,
    this.selectedDate,
    this.selectedTime,
    this.patientName = '',
    this.patientPhone = '',
    this.notes = '',
    this.bookingRef,
  });
}

class BookingSubmitting extends BookingStates {}

class BookingSuccessState extends BookingStates {}

class BookingErrorState extends BookingStates {
  final String message;
  BookingErrorState(this.message);
}
