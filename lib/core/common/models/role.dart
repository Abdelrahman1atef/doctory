enum UserRole {
  superAdmin,
  clinicOwner,
  clinicManager,
  doctor,
  clinicStaff,
  patient;

  static UserRole? fromJson(String? value) {
    if (value == null) return null;
    for (final r in UserRole.values) {
      if (r.name.toLowerCase() == value.toLowerCase()) return r;
    }
    return null;
  }

  String toJson() => name;
}

enum Permission {
  viewAdminDashboard,
  manageClinics,
  manageDoctors,
  manageUsers,
  manageSubscriptions,
  managePayments,
  manageAds,
  manageSpecializations,
  reviewPendingClinics,
  manageSupportTickets,
  viewClinicDashboard,
  manageClinicSettings,
  manageClinicLocation,
  manageAppointments,
  manageMedicalRecords,
  manageBilling,
  manageInventory,
  manageClinicStaff,
  manageClinicDoctors,
  bookAppointment,
  viewOwnMedicalRecords,
  rateClinic,
  viewOwnBilling;

  static Permission? fromJson(String? value) {
    if (value == null) return null;
    for (final p in Permission.values) {
      if (p.name.toLowerCase() == value.toLowerCase()) return p;
    }
    return null;
  }
}

enum DoctorEmploymentType {
  freelance,
  ownClinic,
  inCenter;

  static DoctorEmploymentType? fromJson(String? value) {
    if (value == null) return null;
    for (final t in DoctorEmploymentType.values) {
      if (t.name.toLowerCase() == value.toLowerCase()) return t;
    }
    return null;
  }
}

enum MobileRole {
  patient,
  freelanceDoctor,
  clinic;

  static MobileRole from({
    required UserRole role,
    DoctorEmploymentType? doctorType,
  }) {
    if (role == UserRole.patient) return MobileRole.patient;
    if (role == UserRole.doctor && doctorType == DoctorEmploymentType.freelance) {
      return MobileRole.freelanceDoctor;
    }
    return MobileRole.clinic;
  }
}
