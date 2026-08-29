import 'package:doctory/core/common/models/shared_models.dart';
import '../domain/enums/appointment_type.dart';
import '../domain/enums/booking_step.dart';
import '../domain/enums/gender.dart';
import '../domain/enums/payment_method.dart';
import '../data/model/appointment_response_dto.dart';

sealed class BookingState {}

class BookingInitial extends BookingState {}

class BookingData extends BookingState {
  final BookingStep currentStep;
  final DoctorModel doctor;
  final String clinicId;
  final AppointmentType appointmentType;
  final PaymentMethod paymentMethod;
  final DateTime? selectedDate;
  final List<TimeSlotModel>? availableSlots;
  final TimeSlotModel? selectedTime;
  final bool isSlotsLoading;
  final String? slotsError;
  final String patientName;
  final String patientAge;
  final Gender patientGender;
  final String complaint;
  final String notes;
  final AppointmentResponseDto? appointment;
  final bool isSubmitting;
  final String? submissionError;
  final String? paymentRedirectUrl;

  BookingData({
    required this.doctor,
    this.currentStep = BookingStep.appointmentType,
    this.clinicId = '',
    this.appointmentType = AppointmentType.inPerson,
    this.paymentMethod = PaymentMethod.wallet,
    this.selectedDate,
    this.availableSlots,
    this.selectedTime,
    this.patientName = '',
    this.patientAge = '',
    this.patientGender = Gender.male,
    this.complaint = '',
    this.notes = '',
    this.appointment,
    this.isSlotsLoading = false,
    this.slotsError,
    this.isSubmitting = false,
    this.submissionError,
    this.paymentRedirectUrl,
  });
}
