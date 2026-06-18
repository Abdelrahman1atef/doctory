import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import '../domain/enums/appointment_type.dart';
import '../domain/enums/booking_step.dart';
import '../domain/enums/gender.dart';
import '../domain/repositories/booking_repository.dart';
import '../data/model/create_appointment_request_dto.dart';
import '../data/model/payment_dto.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository bookingRepo;
  final DoctorModel doctor;
  final String clinicId;

  BookingCubit({
    required this.bookingRepo,
    required this.doctor,
    required this.clinicId,
  }) : super(BookingInitial()) {
    emit(BookingData(doctor: doctor, clinicId: clinicId));
  }

  BookingData get _data => state is BookingData ? state as BookingData : BookingData(doctor: doctor, clinicId: clinicId);

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
        patientPhone: data.patientPhone,
        patientAge: data.patientAge,
        patientGender: data.patientGender,
        complaint: data.complaint,
        notes: data.notes,
        reservation: data.reservation,
        payment: data.payment,
        verification: data.verification,
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
        patientPhone: data.patientPhone,
        patientAge: data.patientAge,
        patientGender: data.patientGender,
        complaint: data.complaint,
        notes: data.notes,
        reservation: data.reservation,
        payment: data.payment,
        verification: data.verification,
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
      patientPhone: data.patientPhone,
      patientAge: data.patientAge,
      patientGender: data.patientGender,
      complaint: data.complaint,
      notes: data.notes,
      reservation: data.reservation,
      payment: data.payment,
      verification: data.verification,
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
      patientPhone: data.patientPhone,
      patientAge: data.patientAge,
      patientGender: data.patientGender,
      complaint: data.complaint,
      notes: data.notes,
      reservation: data.reservation,
      payment: data.payment,
      verification: data.verification,
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
      patientPhone: data.patientPhone,
      patientAge: data.patientAge,
      patientGender: data.patientGender,
      complaint: data.complaint,
      notes: data.notes,
      reservation: data.reservation,
      payment: data.payment,
      verification: data.verification,
    ));
    await fetchAvailableSlots(date);
  }

  Future<void> fetchAvailableSlots(DateTime date) async {
    final data = _data;
    if (data.isSlotsLoading) return;

    emit(BookingData(
      doctor: data.doctor,
      clinicId: data.clinicId,
      currentStep: data.currentStep,
      appointmentType: data.appointmentType,
      selectedDate: data.selectedDate,
      selectedTime: null,
      availableSlots: null,
      isSlotsLoading: true,
      slotsError: null,
      patientName: data.patientName,
      patientPhone: data.patientPhone,
      patientAge: data.patientAge,
      patientGender: data.patientGender,
      complaint: data.complaint,
      notes: data.notes,
      reservation: data.reservation,
      payment: data.payment,
      verification: data.verification,
    ));

    final result = await bookingRepo.getAvailableSlots(
      doctorId: doctor.id,
      clinicId: clinicId,
      date: date,
    );

    if (state is! BookingData) return;

    result.fold(
      onSuccess: (slotsData) {
        final current = _data;
        emit(BookingData(
          doctor: current.doctor,
          clinicId: current.clinicId,
          currentStep: current.currentStep,
          appointmentType: current.appointmentType,
          selectedDate: current.selectedDate,
          availableSlots: slotsData.slots,
          selectedTime: current.selectedTime,
          patientName: current.patientName,
          patientPhone: current.patientPhone,
          patientAge: current.patientAge,
          patientGender: current.patientGender,
          complaint: current.complaint,
          notes: current.notes,
          reservation: current.reservation,
          payment: current.payment,
          verification: current.verification,
        ));
      },
      onFailure: (failure) {
        final current = _data;
        emit(BookingData(
          doctor: current.doctor,
          clinicId: current.clinicId,
          currentStep: current.currentStep,
          appointmentType: current.appointmentType,
          selectedDate: current.selectedDate,
          availableSlots: current.availableSlots,
          selectedTime: current.selectedTime,
          isSlotsLoading: false,
          slotsError: failure.message,
          patientName: current.patientName,
          patientPhone: current.patientPhone,
          patientAge: current.patientAge,
          patientGender: current.patientGender,
          complaint: current.complaint,
          notes: current.notes,
          reservation: current.reservation,
          payment: current.payment,
          verification: current.verification,
        ));
      },
    );
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
      patientPhone: data.patientPhone,
      patientAge: data.patientAge,
      patientGender: data.patientGender,
      complaint: data.complaint,
      notes: data.notes,
      reservation: data.reservation,
      payment: data.payment,
      verification: data.verification,
    ));
  }

  void updatePatientInfo({
    String? name,
    String? phone,
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
      patientPhone: phone ?? data.patientPhone,
      patientAge: age ?? data.patientAge,
      patientGender: gender ?? data.patientGender,
      complaint: complaint ?? data.complaint,
      notes: notes ?? data.notes,
      reservation: data.reservation,
      payment: data.payment,
      verification: data.verification,
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
      patientPhone: data.patientPhone,
      patientAge: data.patientAge,
      patientGender: data.patientGender,
      complaint: data.complaint,
      notes: data.notes,
      reservation: data.reservation,
      payment: data.payment,
      verification: data.verification,
      isSubmitting: true,
      submissionError: null,
    ));

    final request = CreateAppointmentRequestDto(
      doctorId: doctor.id,
      clinicId: clinicId,
      appointmentDate: data.selectedDate!,
      startTime: '${data.selectedTime!.startTime.hour.toString().padLeft(2, '0')}:${data.selectedTime!.startTime.minute.toString().padLeft(2, '0')}',
      endTime: '${data.selectedTime!.endTime.hour.toString().padLeft(2, '0')}:${data.selectedTime!.endTime.minute.toString().padLeft(2, '0')}',
      appointmentType: data.appointmentType.value,
      patientFullName: data.patientName,
      patientPhoneNumber: data.patientPhone,
      patientAge: data.patientAge,
      patientGender: data.patientGender.value,
      complaint: data.complaint,
      chronicDiseases: data.notes.isEmpty ? null : data.notes,
    );

    final result = await bookingRepo.createReservation(request);

    if (state is! BookingData) return false;

    return result.fold(
      onSuccess: (reservation) {
        final current = _data;
        emit(BookingData(
          doctor: current.doctor,
          clinicId: current.clinicId,
          currentStep: BookingStep.payment,
          appointmentType: current.appointmentType,
          selectedDate: current.selectedDate,
          availableSlots: current.availableSlots,
          selectedTime: current.selectedTime,
          patientName: current.patientName,
          patientPhone: current.patientPhone,
          patientAge: current.patientAge,
          patientGender: current.patientGender,
          complaint: current.complaint,
          notes: current.notes,
          reservation: reservation,
          payment: current.payment,
          verification: current.verification,
          isSubmitting: false,
          submissionError: null,
        ));
        return true;
      },
      onFailure: (failure) {
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
          patientPhone: current.patientPhone,
          patientAge: current.patientAge,
          patientGender: current.patientGender,
          complaint: current.complaint,
          notes: current.notes,
          reservation: current.reservation,
          payment: current.payment,
          verification: current.verification,
          isSubmitting: false,
          submissionError: failure.message,
        ));
        return false;
      },
    );
  }

  Future<bool> processPayment() async {
    final data = _data;
    if (data.reservation == null) return false;

    emit(BookingData(
      doctor: data.doctor,
      clinicId: data.clinicId,
      currentStep: data.currentStep,
      appointmentType: data.appointmentType,
      selectedDate: data.selectedDate,
      availableSlots: data.availableSlots,
      selectedTime: data.selectedTime,
      patientName: data.patientName,
      patientPhone: data.patientPhone,
      patientAge: data.patientAge,
      patientGender: data.patientGender,
      complaint: data.complaint,
      notes: data.notes,
      reservation: data.reservation,
      payment: data.payment,
      verification: data.verification,
      isSubmitting: true,
      submissionError: null,
    ));

    final request = PaymentRequestDto(
      reservationId: data.reservation!.reservationId,
      amount: data.reservation!.amount,
      currency: data.reservation!.currency,
      paymentMethod: 'credit_card',
    );

    final result = await bookingRepo.processPayment(request);

    if (state is! BookingData) return false;

    return result.fold(
      onSuccess: (payment) {
        final current = _data;
        emit(BookingData(
          doctor: current.doctor,
          clinicId: current.clinicId,
          currentStep: BookingStep.verification,
          appointmentType: current.appointmentType,
          selectedDate: current.selectedDate,
          availableSlots: current.availableSlots,
          selectedTime: current.selectedTime,
          patientName: current.patientName,
          patientPhone: current.patientPhone,
          patientAge: current.patientAge,
          patientGender: current.patientGender,
          complaint: current.complaint,
          notes: current.notes,
          reservation: current.reservation,
          payment: payment,
          verification: current.verification,
          isSubmitting: false,
          submissionError: null,
        ));
        return true;
      },
      onFailure: (failure) {
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
          patientPhone: current.patientPhone,
          patientAge: current.patientAge,
          patientGender: current.patientGender,
          complaint: current.complaint,
          notes: current.notes,
          reservation: current.reservation,
          payment: current.payment,
          verification: current.verification,
          isSubmitting: false,
          submissionError: failure.message,
        ));
        return false;
      },
    );
  }

  Future<bool> verifyPayment() async {
    final data = _data;
    if (data.payment == null || data.payment!.transactionId == null) {
      return false;
    }

    emit(BookingData(
      doctor: data.doctor,
      clinicId: data.clinicId,
      currentStep: data.currentStep,
      appointmentType: data.appointmentType,
      selectedDate: data.selectedDate,
      availableSlots: data.availableSlots,
      selectedTime: data.selectedTime,
      patientName: data.patientName,
      patientPhone: data.patientPhone,
      patientAge: data.patientAge,
      patientGender: data.patientGender,
      complaint: data.complaint,
      notes: data.notes,
      reservation: data.reservation,
      payment: data.payment,
      verification: data.verification,
      isSubmitting: true,
      submissionError: null,
    ));

    final result = await bookingRepo.verifyPayment(
      paymentId: data.payment!.paymentId,
      transactionId: data.payment!.transactionId!,
    );

    if (state is! BookingData) return false;

    return result.fold(
      onSuccess: (verification) {
        final current = _data;
        final isCompleted = verification.status == 'completed';
        emit(BookingData(
          doctor: current.doctor,
          clinicId: current.clinicId,
          currentStep: isCompleted ? BookingStep.success : current.currentStep,
          appointmentType: current.appointmentType,
          selectedDate: current.selectedDate,
          availableSlots: current.availableSlots,
          selectedTime: current.selectedTime,
          patientName: current.patientName,
          patientPhone: current.patientPhone,
          patientAge: current.patientAge,
          patientGender: current.patientGender,
          complaint: current.complaint,
          notes: current.notes,
          reservation: current.reservation,
          payment: current.payment,
          verification: verification,
          isSubmitting: false,
          submissionError: isCompleted ? null : 'Payment verification failed. Please try again.',
        ));
        return isCompleted;
      },
      onFailure: (failure) {
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
          patientPhone: current.patientPhone,
          patientAge: current.patientAge,
          patientGender: current.patientGender,
          complaint: current.complaint,
          notes: current.notes,
          reservation: current.reservation,
          payment: current.payment,
          verification: current.verification,
          isSubmitting: false,
          submissionError: failure.message,
        ));
        return false;
      },
    );
  }

  void retrySlotFetch() {
    final data = _data;
    if (data.selectedDate != null) {
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
      patientPhone: data.patientPhone,
      patientAge: data.patientAge,
      patientGender: data.patientGender,
      complaint: data.complaint,
      notes: data.notes,
      reservation: data.reservation,
      payment: data.payment,
      verification: data.verification,
      isSubmitting: false,
      submissionError: null,
    ));
  }

  void reset() {
    emit(BookingData(doctor: doctor, clinicId: clinicId));
  }
}
