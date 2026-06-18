class ReviewModel {
  final String id;
  final String patientName;
  final String? patientAvatar;
  final double rating;
  final double cleanlinessRating;
  final double behaviorRating;
  final double receptionRating;
  final String comment;
  final DateTime date;

  ReviewModel({
    required this.id,
    required this.patientName,
    this.patientAvatar,
    required this.rating,
    required this.cleanlinessRating,
    required this.behaviorRating,
    required this.receptionRating,
    required this.comment,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      patientName: json['patientName'] ?? '',
      patientAvatar: json['patientAvatar'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      cleanlinessRating: (json['cleanlinessRating'] ?? 0.0).toDouble(),
      behaviorRating: (json['behaviorRating'] ?? 0.0).toDouble(),
      receptionRating: (json['receptionRating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientName': patientName,
      'patientAvatar': patientAvatar,
      'rating': rating,
      'cleanlinessRating': cleanlinessRating,
      'behaviorRating': behaviorRating,
      'receptionRating': receptionRating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }
}
