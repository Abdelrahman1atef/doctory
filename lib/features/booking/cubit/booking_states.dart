import 'package:doctory/core/common/models/shared_models.dart';

/// The steps of the booking flow
enum BookingStep { selectDate, selectTime, confirm, success }

abstract class BookingStates {}

class BookingInitial extends BookingStates {}

class BookingSlotsLoading extends BookingStates {}

class BookingSlotsError extends BookingStates {
  final String message;
  BookingSlotsError(this.message);
}

class BookingStateUpdated extends BookingStates {
  final DoctorModel doctor;
  final String? clinicId;
  final BookingStep currentStep;
  final DateTime? selectedDate;
  final List<TimeSlotModel>? availableSlots;
  final TimeSlotModel? selectedTime;
  final String patientName;
  final String patientPhone;
  final String patientAge;
  final int patientGender; // 1 = Male, 2 = Female
  final int appointmentType; // 1 = InPerson, 2 = Online, 3 = FollowUp
  final String complaint;
  final String notes;
  final String? bookingRef;

  BookingStateUpdated({
    required this.doctor,
    this.clinicId,
    this.currentStep = BookingStep.selectDate,
    this.selectedDate,
    this.availableSlots,
    this.selectedTime,
    this.patientName = '',
    this.patientPhone = '',
    this.patientAge = '',
    this.patientGender = 1,
    this.appointmentType = 1,
    this.complaint = '',
    this.notes = '',
    this.bookingRef,
  });

  BookingStateUpdated copyWith({
    BookingStep? currentStep,
    DateTime? selectedDate,
    List<TimeSlotModel>? availableSlots,
    TimeSlotModel? selectedTime,
    String? patientName,
    String? patientPhone,
    String? patientAge,
    int? patientGender,
    int? appointmentType,
    String? complaint,
    String? notes,
    String? bookingRef,
  }) {
    return BookingStateUpdated(
      doctor: doctor,
      clinicId: clinicId,
      currentStep: currentStep ?? this.currentStep,
      selectedDate: selectedDate ?? this.selectedDate,
      availableSlots: availableSlots ?? this.availableSlots,
      selectedTime: selectedTime ?? this.selectedTime,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      appointmentType: appointmentType ?? this.appointmentType,
      complaint: complaint ?? this.complaint,
      notes: notes ?? this.notes,
      bookingRef: bookingRef ?? this.bookingRef,
    );
  }
}

class BookingSubmitting extends BookingStates {}

class BookingSuccessState extends BookingStates {}

class BookingErrorState extends BookingStates {
  final String message;
  BookingErrorState(this.message);
}
