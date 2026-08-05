class PublicAdModel {
  final String id;
  final String clinicId;
  final String? clinicName;
  final String? clinicLogoUrl;
  final String? imageUrl;
  final String packageId;
  final String? packageNameAr;
  final String? title;
  final String startDate;
  final String endDate;

  PublicAdModel({
    required this.id,
    required this.clinicId,
    this.clinicName,
    this.clinicLogoUrl,
    this.imageUrl,
    required this.packageId,
    this.packageNameAr,
    this.title,
    required this.startDate,
    required this.endDate,
  });

  factory PublicAdModel.fromJson(Map<String, dynamic> json) {
    return PublicAdModel(
      id: json['id']?.toString() ?? '',
      clinicId: json['clinicId']?.toString() ?? '',
      clinicName: json['clinicName'] as String?,
      clinicLogoUrl: json['clinicLogoUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      packageId: json['packageId']?.toString() ?? '',
      packageNameAr: json['packageNameAr'] as String?,
      title: json['title'] as String?,
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clinicId': clinicId,
      'clinicName': clinicName,
      'clinicLogoUrl': clinicLogoUrl,
      'imageUrl': imageUrl,
      'packageId': packageId,
      'packageNameAr': packageNameAr,
      'title': title,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}