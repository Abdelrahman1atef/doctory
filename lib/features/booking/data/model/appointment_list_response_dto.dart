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
    final data = json['data'] ?? json;
    return AppointmentListResponseDto(
      items: (data['items'] as List<dynamic>?)
              ?.map((e) =>
                  AppointmentResponseDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pageNumber: data['pageNumber'] as int? ?? 1,
      pageSize: data['pageSize'] as int? ?? 10,
      totalPages: data['totalPages'] as int? ?? 1,
      totalCount: data['totalCount'] as int? ?? 0,
      hasPreviousPage: data['hasPreviousPage'] as bool? ?? false,
      hasNextPage: data['hasNextPage'] as bool? ?? false,
    );
  }
}
