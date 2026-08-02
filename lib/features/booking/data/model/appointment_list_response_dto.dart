import 'appointment_response_dto.dart';

class AppointmentListResponseDto {
  final List<AppointmentResponseDto> items;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final int totalCount;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const AppointmentListResponseDto({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.totalCount,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory AppointmentListResponseDto.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    // Case 1: flat array — { data: [ {...}, {...} ] }
    if (rawData is List) {
      final items = rawData
          .whereType<Map<String, dynamic>>()
          .map((e) => AppointmentResponseDto.fromJson(e))
          .toList();
      return AppointmentListResponseDto(
        items: items,
        pageNumber: 1,
        pageSize: items.length,
        totalPages: 1,
        totalCount: items.length,
        hasPreviousPage: false,
        hasNextPage: false,
      );
    }

    // Case 2: paged object — { data: { items: [...], pageNumber: ... } }
    final data = rawData is Map<String, dynamic> ? rawData : json;
    final rawItems = data['items'] ?? data['appointments'] ?? data['data'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map((e) => AppointmentResponseDto.fromJson(e))
            .toList()
        : <AppointmentResponseDto>[];
    return AppointmentListResponseDto(
      items: items,
      pageNumber: data['pageNumber'] as int? ?? 1,
      pageSize: data['pageSize'] as int? ?? 10,
      totalPages: data['totalPages'] as int? ?? 1,
      totalCount: data['totalCount'] as int? ?? items.length,
      hasPreviousPage: data['hasPreviousPage'] as bool? ?? false,
      hasNextPage: data['hasNextPage'] as bool? ?? false,
    );
  }
}
