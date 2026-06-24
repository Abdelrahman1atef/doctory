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

  factory TimeSlotModel.fromJson(Map<String, dynamic> json, {DateTime? date}) {
    return TimeSlotModel(
      id: json['id']?.toString() ?? '',
      startTime: _parseTime(json['startTime'], date),
      endTime: _parseTime(json['endTime'], date),
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  static DateTime _parseTime(dynamic value, DateTime? baseDate) {
    if (value == null) return baseDate ?? DateTime.now();
    final str = value.toString();
    try {
      return DateTime.parse(str);
    } on FormatException {
      final parts = str.split(':');
      if (parts.length >= 2) {
        final h = int.tryParse(parts[0]) ?? 0;
        final m = int.tryParse(parts[1]) ?? 0;
        final now = baseDate ?? DateTime.now();
        return DateTime(now.year, now.month, now.day, h, m);
      }
      rethrow;
    }
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
