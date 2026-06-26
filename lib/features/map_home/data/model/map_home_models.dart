import 'package:doctory/core/common/models/clinic_model.dart';

class ClinicSearchResponse {
  final List<ClinicModel> items;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final int totalCount;
  final bool hasPreviousPage;
  final bool hasNextPage;

  ClinicSearchResponse({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.totalCount,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory ClinicSearchResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] ?? json;
    if (rawData is List) {
      final clinics = rawData
          .map((e) => ClinicModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ClinicSearchResponse(
        items: clinics,
        pageNumber: 1,
        pageSize: clinics.length,
        totalPages: 1,
        totalCount: clinics.length,
        hasPreviousPage: false,
        hasNextPage: false,
      );
    }
    final data = rawData as Map<String, dynamic>;
    return ClinicSearchResponse(
      items:
          (data['items'] as List?)
              ?.map((e) => ClinicModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pageNumber: data['pageNumber'] ?? 1,
      pageSize: data['pageSize'] ?? 20,
      totalPages: data['totalPages'] ?? 1,
      totalCount: data['totalCount'] ?? 0,
      hasPreviousPage: data['hasPreviousPage'] ?? false,
      hasNextPage: data['hasNextPage'] ?? false,
    );
  }
}
