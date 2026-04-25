class TimeSlotModel {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;

  TimeSlotModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id']?.toString() ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'isAvailable': isAvailable,
    };
  }
}
