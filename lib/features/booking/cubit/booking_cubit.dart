import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import '../../../core/error/failures.dart';
import '../domain/enums/appointment_type.dart';
import '../domain/enums/booking_step.dart';
import '../domain/enums/gender.dart';
import '../domain/repositories/booking_repository.dart';
import '../data/model/create_appointment_request_dto.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository bookingRepo;
  final DoctorModel doctor;
  final String clinicId;

  BookingCubit({required this.bookingRepo, required this.doctor, required this.clinicId})
    : super(BookingInitial()) {
    emit(BookingData(doctor: doctor, clinicId: clinicId));
  }

  BookingData get _data =>
      state is BookingData ? state as BookingData : BookingData(doctor: doctor, clinicId: clinicId);

  void nextStep() {
    final data = _data;
    const steps = BookingStep.values;
    final currentIndex = steps.indexOf(data.currentStep);
    if (currentIndex < steps.length - 1) {
      emit(BookingData(
        doctor: data.doctor,
        clinicId: data.clinicId,
        currentStep: steps[currentIndex + 1],
        appointmentType: data.appointmentType,
        selectedDate: data.selectedDate,
        availableSlots: data.availableSlots,
        selectedTime: data.selectedTime,
        patientName: data.patientName,
        patientAge: data.patientAge,
        patientGender: data.patientGender,
        complaint: data.complaint,
        notes: data.notes,
        appointment: data.appointment,
        paymentMethod: data.paymentMethod,
        isSubmitting: data.isSubmitting,
        submissionError: data.submissionError,
      ));
    }
  }

  void previousStep() {
    final data = _data;
    const steps = BookingStep.values;
    final currentIndex = steps.indexOf(data.currentStep);
    if (currentIndex > 0) {
      emit(BookingData(
        doctor: data.doctor,
        clinicId: data.clinicId,
        currentStep: steps[currentIndex - 1],
        appointmentType: data.appointmentType,
        selectedDate: data.selectedDate,
        availableSlots: data.availableSlots,
        selectedTime: data.selectedTime,
        patientName: data.patientName,
        patientAge: data.patientAge,
        patientGender: data.patientGender,
        complaint: data.complaint,
        notes: data.notes,
        appointment: data.appointment,
        paymentMethod: data.paymentMethod,
        isSubmitting: data.isSubmitting,
        submissionError: data.submissionError,
      ));
    }
  }

  void goToStep(BookingStep step) {
    final data = _data;
    emit(BookingData(
      doctor: data.doctor,
      clinicId: data.clinicId,
      currentStep: step,
      appointmentType: data.appointmentType,
      selectedDate: data.selectedDate,
      availableSlots: data.availableSlots,
      selectedTime: data.selectedTime,
      patientName: data.patientName,
      patientAge: data.patientAge,
      patientGender: data.patientGender,
      complaint: data.complaint,
      notes: data.notes,
      appointment: data.appointment,
      isSubmitting: data.isSubmitting,
      submissionError: data.submissionError,
    ));
  }

  void selectAppointmentType(AppointmentType type) {
    final data = _data;
    emit(BookingData(
      doctor: data.doctor,
      clinicId: data.clinicId,
      currentStep: data.currentStep,
      appointmentType: type,
      selectedDate: data.selectedDate,
      availableSlots: data.availableSlots,
      selectedTime: data.selectedTime,
      patientName: data.patientName,
      patientAge: data.patientAge,
      patientGender: data.patientGender,
      complaint: data.complaint,
      notes: data.notes,
      appointment: data.appointment,
    ));
  }

  Future<void> selectDate(DateTime date) async {
    final data = _data;
    emit(BookingData(
      doctor: data.doctor,
      clinicId: data.clinicId,
      currentStep: data.currentStep,
      appointmentType: data.appointmentType,
      selectedDate: date,
      selectedTime: null,
      availableSlots: null,
      isSlotsLoading: true,
      slotsError: null,
      patientName: data.patientName,
      patientAge: data.patientAge,
      patientGender: data.patientGender,
      complaint: data.complaint,
      notes: data.notes,
      appointment: data.appointment,
      paymentMethod: data.paymentMethod,
    ));
    await fetchAvailableSlots(date);
  }

  Future<void> fetchAvailableSlots(DateTime date) async {
    final data = _data;
    final slots =
        doctor.availabilities?.expand((a) => a.slotsForDate(date)).toList() ??
            [];

    if (state is! BookingData) return;

    emit(BookingData(
      doctor: data.doctor,
      clinicId: data.clinicId,
      currentStep: data.currentStep,
      appointmentType: data.appointmentType,
      selectedDate: data.selectedDate,
      availableSlots: slots,
      selectedTime: null,
      isSlotsLoading: false,
      slotsError: null,
      patientName: data.patientName,
      patientAge: data.patientAge,
      patientGender: data.patientGender,
      complaint: data.complaint,
      notes: data.notes,
      appointment: data.appointment,
      paymentMethod: data.paymentMethod,
    ));
  }

  void selectTime(TimeSlotModel time) {
    final data = _data;
    emit(BookingData(
      doctor: data.doctor,
      clinicId: data.clinicId,
      currentStep: data.currentStep,
      appointmentType: data.appointmentType,
      selectedDate: data.selectedDate,
      availableSlots: data.availableSlots,
      selectedTime: time,
      patientName: data.patientName,
      patientAge: data.patientAge,
      patientGender: data.patientGender,
      complaint: data.complaint,
      notes: data.notes,
      appointment: data.appointment,
      paymentMethod: data.paymentMethod,
    ));
  }

  void updatePatientInfo({
    String? name,
    String? age,
    Gender? gender,
    String? complaint,
    String? notes,
  }) {
    final data = _data;
    emit(BookingData(
      doctor: data.doctor,
      clinicId: data.clinicId,
      currentStep: data.currentStep,
      appointmentType: data.appointmentType,
      selectedDate: data.selectedDate,
      availableSlots: data.availableSlots,
      selectedTime: data.selectedTime,
      patientName: name ?? data.patientName,
      patientAge: age ?? data.patientAge,
      patientGender: gender ?? data.patientGender,
      complaint: complaint ?? data.complaint,
      notes: notes ?? data.notes,
      appointment: data.appointment,
      paymentMethod: data.paymentMethod,
    ));
  }

  Future<bool> submitBooking() async {
    final data = _data;
    if (data.selectedDate == null || data.selectedTime == null) return false;

    emit(BookingData(
      doctor: data.doctor,
      clinicId: data.clinicId,
      currentStep: data.currentStep,
      appointmentType: data.appointmentType,
      selectedDate: data.selectedDate,
      availableSlots: data.availableSlots,
      selectedTime: data.selectedTime,
      patientName: data.patientName,
      patientAge: data.patientAge,
      patientGender: data.patientGender,
      complaint: data.complaint,
      notes: data.notes,
      appointment: data.appointment,
      isSubmitting: true,
      submissionError: null,
    ));

    final request = CreateAppointmentRequestDto(
      doctorId: doctor.id,
      clinicId: clinicId,
      appointmentDate: data.selectedDate!,
      startTime:
          '${data.selectedTime!.startTime.hour.toString().padLeft(2, '0')}:${data.selectedTime!.startTime.minute.toString().padLeft(2, '0')}',
      endTime:
          '${data.selectedTime!.endTime.hour.toString().padLeft(2, '0')}:${data.selectedTime!.endTime.minute.toString().padLeft(2, '0')}',
      appointmentType: data.appointmentType.value,
      patientFullName: data.patientName,
      patientAge: data.patientAge,
      patientGender: data.patientGender.value,
      complaint: data.complaint,
      chronicDiseases: data.notes.isEmpty ? null : data.notes,
    );


    final result = await bookingRepo.createAppointment(request);

    if (state is! BookingData) return false;

    return await result.fold(
      onSuccess: (appointment) async {
        final current = _data;

        // Booking stops here: the patient does not pay yet. The clinic has to
        // accept the request first, and payment is then initiated from the
        // My Appointments screen.
        emit(BookingData(
          doctor: current.doctor,
          clinicId: current.clinicId,
          currentStep: BookingStep.success,
          appointmentType: current.appointmentType,
          selectedDate: current.selectedDate,
          availableSlots: current.availableSlots,
          selectedTime: current.selectedTime,
          patientName: current.patientName,
          patientAge: current.patientAge,
          patientGender: current.patientGender,
          complaint: current.complaint,
          notes: current.notes,
          appointment: appointment,
          paymentMethod: current.paymentMethod,
          isSubmitting: false,
          submissionError: null,
        ));
        return true;
      },
      onFailure: (failure) async {
        final current = _data;
        emit(BookingData(
          doctor: current.doctor,
          clinicId: current.clinicId,
          currentStep: current.currentStep,
          appointmentType: current.appointmentType,
          selectedDate: current.selectedDate,
          availableSlots: current.availableSlots,
          selectedTime: current.selectedTime,
          patientName: current.patientName,
          patientAge: current.patientAge,
          patientGender: current.patientGender,
          complaint: current.complaint,
          notes: current.notes,
          appointment: current.appointment,
          paymentMethod: current.paymentMethod,
          isSubmitting: false,
          submissionError: failure.userMessage,
        ));
        return false;
      },
    );
  }

  void retrySlotFetch() {
    final data = _data;
    if (data.selectedDate != null && !data.isSlotsLoading) {
      fetchAvailableSlots(data.selectedDate!);
    }
  }

  void clearError() {
    final data = _data;
    emit(BookingData(
      doctor: data.doctor,
      clinicId: data.clinicId,
      currentStep: data.currentStep,
      appointmentType: data.appointmentType,
      selectedDate: data.selectedDate,
      availableSlots: data.availableSlots,
      selectedTime: data.selectedTime,
      patientName: data.patientName,
      patientAge: data.patientAge,
      patientGender: data.patientGender,
      complaint: data.complaint,
      notes: data.notes,
      appointment: data.appointment,
      isSubmitting: false,
      submissionError: null,
    ));
  }

  void reset() {
    emit(BookingData(doctor: doctor, clinicId: clinicId));
  }
}
