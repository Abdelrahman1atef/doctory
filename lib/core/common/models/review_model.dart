/// A single patient rating row as displayed in the reviews list.
class ReviewModel {
  final String id;
  final String? userId;
  final String patientName;
  final double rating;
  final String comment;
  final DateTime date;
  final int type;

  ReviewModel({
    required this.id,
    this.userId,
    required this.patientName,
    required this.rating,
    required this.comment,
    required this.date,
    this.type = 0,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString(),
      patientName: json['patientName'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      type: (json['type'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'patientName': patientName,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'type': type,
    };
  }
}