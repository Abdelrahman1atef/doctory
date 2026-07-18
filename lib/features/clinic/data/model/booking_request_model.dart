enum BookingStatus { pending, accepted, rejected }

enum AppointmentType { inPerson, followUp }

class BookingRequestModel {
  final String id;
  final String patientName;
  final String? patientPhone;
  final int? patientAge;
  final String clinicName;
  final String? doctorName;
  final String requestedDate;
  final String requestedTime;
  final String? reason;
  final AppointmentType appointmentType;
  final BookingStatus status;
  final DateTime createdAt;

  BookingRequestModel({
    required this.id,
    required this.patientName,
    this.patientPhone,
    this.patientAge,
    required this.clinicName,
    this.doctorName,
    required this.requestedDate,
    required this.requestedTime,
    this.reason,
    this.appointmentType = AppointmentType.inPerson,
    required this.status,
    required this.createdAt,
  });

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) {
    return BookingRequestModel(
      id: json['id']?.toString() ?? '',
      patientName: json['patientName'] as String? ?? '',
      patientPhone: json['patientPhone'] as String?,
      patientAge: json['patientAge'] as int?,
      clinicName: json['clinicName'] as String? ?? '',
      doctorName: json['doctorName'] as String?,
      requestedDate: json['requestedDate'] as String? ?? '',
      requestedTime: json['requestedTime'] as String? ?? '',
      reason: json['reason'] as String?,
      appointmentType: _parseAppointmentType(json['appointmentType']),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  static AppointmentType _parseAppointmentType(dynamic value) {
    if (value == null) return AppointmentType.inPerson;
    switch (value.toString().toLowerCase()) {
      case 'followup':
      case 'follow_up':
        return AppointmentType.followUp;
      default:
        return AppointmentType.inPerson;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientName': patientName,
      'patientPhone': patientPhone,
      'patientAge': patientAge,
      'clinicName': clinicName,
      'doctorName': doctorName,
      'requestedDate': requestedDate,
      'requestedTime': requestedTime,
      'reason': reason,
      'appointmentType': appointmentType.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class PaginatedBookingsResponse {
  final List<BookingRequestModel> items;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final int totalCount;
  final bool hasPreviousPage;
  final bool hasNextPage;

  PaginatedBookingsResponse({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.totalCount,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory PaginatedBookingsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedBookingsResponse(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => BookingRequestModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pageNumber: json['pageNumber'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 0,
      totalCount: json['totalCount'] as int? ?? 0,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
    );
  }
}
