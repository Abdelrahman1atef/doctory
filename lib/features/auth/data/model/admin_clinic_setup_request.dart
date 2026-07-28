class AdminClinicSetupRequest {
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;
  final String? website;
  final String? logo;
  final String workingHours;
  final String workingHoursStart;
  final String workingHoursEnd;
  final List<String> workingDays;
  final String specializationId;
  final double lat;
  final double lng;

  AdminClinicSetupRequest({
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    this.website,
    this.logo,
    required this.workingHours,
    required this.workingHoursStart,
    required this.workingHoursEnd,
    required this.workingDays,
    required this.specializationId,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
      'logo': logo,
      'workingHours': workingHours,
      'workingHoursStart': workingHoursStart,
      'workingHoursEnd': workingHoursEnd,
      'workingDays': workingDays,
      'specializationId': specializationId,
      'lat': lat,
      'lng': lng,
    };
  }
}
