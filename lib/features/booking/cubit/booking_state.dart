import 'package:doctory/core/common/models/shared_models.dart';
import '../domain/enums/appointment_type.dart';
import '../domain/enums/booking_step.dart';
import '../domain/enums/gender.dart';
import '../data/model/create_appointment_request_dto.dart';
import '../data/model/payment_dto.dart';

sealed class BookingState {}

class BookingInitial extends BookingState {}

class BookingData extends BookingState {
  final BookingStep currentStep;
  final DoctorModel doctor;
  final String clinicId;
  final AppointmentType appointmentType;
  final DateTime? selectedDate;
  final List<TimeSlotModel>? availableSlots;
  final TimeSlotModel? selectedTime;
  final bool isSlotsLoading;
  final String? slotsError;
  final String patientName;
  final String patientPhone;
  final String patientAge;
  final Gender patientGender;
  final String complaint;
  final String notes;
  final CreateReservationResponseDto? reservation;
  final PaymentResponseDto? payment;
  final PaymentResponseDto? verification;
  final String? paymentUrl;
  final String? pendingPaymentId;
  final bool isSubmitting;
  final String? submissionError;

  BookingData({
    required this.doctor,
    this.currentStep = BookingStep.appointmentType,
    this.clinicId = '',
    this.appointmentType = AppointmentType.inPerson,
    this.selectedDate,
    this.availableSlots,
    this.selectedTime,
    this.patientName = '',
    this.patientPhone = '',
    this.patientAge = '',
    this.patientGender = Gender.male,
    this.complaint = '',
    this.notes = '',
    this.reservation,
    this.payment,
    this.verification,
    this.paymentUrl,
    this.pendingPaymentId,
    this.isSlotsLoading = false,
    this.slotsError,
    this.isSubmitting = false,
    this.submissionError,
  });
}
