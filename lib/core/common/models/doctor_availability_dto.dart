class DoctorAvailabilityDto {
  final String id;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final int slotDurationMinutes;

  DoctorAvailabilityDto({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.slotDurationMinutes = 30,
  });

  factory DoctorAvailabilityDto.fromJson(Map<String, dynamic> json) {
    return DoctorAvailabilityDto(
      id: json['id']?.toString() ?? '',
      dayOfWeek: json['dayOfWeek'] ?? '',
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      slotDurationMinutes: json['slotDurationMinutes'] as int? ?? 30,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'slotDurationMinutes': slotDurationMinutes,
    };
  }
}
