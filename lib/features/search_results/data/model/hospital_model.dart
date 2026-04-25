/// Model representing a hospital/clinic from the search API.
class HospitalModel {
  final String id;
  final String name;
  final String? nameAr;
  final String address;
  final String? addressAr;
  final String? phone;
  final double lat;
  final double lng;
  final bool isRegistered;
  final String? specializationName;
  final double distance; // distance in some unit from API

  HospitalModel({
    required this.id,
    required this.name,
    this.nameAr,
    required this.address,
    this.addressAr,
    this.phone,
    required this.lat,
    required this.lng,
    this.isRegistered = false,
    this.specializationName,
    required this.distance,
  });

  /// The display name: prefer Arabic name if available, fallback to name.
  String get displayName =>
      (nameAr != null && nameAr!.isNotEmpty) ? nameAr! : name;

  /// The display address: prefer Arabic address if available, fallback to address.
  String get displayAddress =>
      (addressAr != null && addressAr!.isNotEmpty) ? addressAr! : address;

  /// Distance formatted in km (API sends distance in some fraction, multiply by 100 for km display).
  String get distanceFormatted {
    final km = distance * 100;
    if (km < 1) {
      return '${(km * 1000).toStringAsFixed(0)} م';
    }
    return '${km.toStringAsFixed(1)} كم';
  }

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      nameAr: json['nameAr'],
      address: json['address'] ?? '',
      addressAr: json['addressAr'],
      phone: json['phone'],
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
      isRegistered: json['isRegistered'] ?? false,
      specializationName: json['specializationName'],
      distance: (json['distance'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'address': address,
      'addressAr': addressAr,
      'phone': phone,
      'lat': lat,
      'lng': lng,
      'isRegistered': isRegistered,
      'specializationName': specializationName,
      'distance': distance,
    };
  }
}
