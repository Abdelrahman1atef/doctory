class ClinicSetupRequest {
  final String name;
  final String phone;
  final double lat;
  final double lng;
  final String address;
  final Map<String, String> operatingHours;

  ClinicSetupRequest({
    required this.name,
    required this.phone,
    required this.lat,
    required this.lng,
    required this.address,
    required this.operatingHours,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'lat': lat,
      'lng': lng,
      'address': address,
      'operatingHours': operatingHours,
    };
  }
}
