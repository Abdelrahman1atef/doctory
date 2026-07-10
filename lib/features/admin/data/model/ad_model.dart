enum AdType { banner, featuredDoctor, featuredClinic }

class AdminAdModel {
  final String id;
  final String title;
  final AdType type;
  final String startDate;
  final String endDate;
  final int sortOrder;
  final int clicks;
  final int impressions;
  final String status;
  final double dailyCost;
  final double totalBudget;
  final String? imageUrl;
  final String? targetUrl;
  final String? linkedEntityId;
  final String? linkedEntityName;
  final String? notes;
  final List<AdTimelineModel>? timeline;

  const AdminAdModel({
    required this.id,
    required this.title,
    this.type = AdType.banner,
    this.startDate = '',
    this.endDate = '',
    this.sortOrder = 0,
    this.clicks = 0,
    this.impressions = 0,
    this.status = 'active',
    this.dailyCost = 0,
    this.totalBudget = 0,
    this.imageUrl,
    this.targetUrl,
    this.linkedEntityId,
    this.linkedEntityName,
    this.notes,
    this.timeline,
  });

  factory AdminAdModel.fromJson(Map<String, dynamic> json) {
    return AdminAdModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      type: _parseType(json['type']),
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,
      clicks: json['clicks'] ?? 0,
      impressions: json['impressions'] ?? 0,
      status: json['status'] ?? 'active',
      dailyCost: (json['dailyCost'] ?? 0).toDouble(),
      totalBudget: (json['totalBudget'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'],
      targetUrl: json['targetUrl'],
      linkedEntityId: json['linkedEntityId']?.toString(),
      linkedEntityName: json['linkedEntityName'],
      notes: json['notes'],
      timeline: (json['timeline'] as List<dynamic>?)
          ?.map((e) => AdTimelineModel.fromJson(e))
          .toList(),
    );
  }

  static AdType _parseType(dynamic value) {
    if (value == null) return AdType.banner;
    switch (value.toString().toLowerCase()) {
      case 'featureddoctor':
      case 'featured_doctor':
        return AdType.featuredDoctor;
      case 'featuredclinic':
      case 'featured_clinic':
        return AdType.featuredClinic;
      default:
        return AdType.banner;
    }
  }

  double get ctr => impressions > 0 ? (clicks / impressions) * 100 : 0;

  AdminAdModel copyWith({String? status}) {
    return AdminAdModel(
      id: id,
      title: title,
      type: type,
      startDate: startDate,
      endDate: endDate,
      sortOrder: sortOrder,
      clicks: clicks,
      impressions: impressions,
      status: status ?? this.status,
      dailyCost: dailyCost,
      totalBudget: totalBudget,
      imageUrl: imageUrl,
      targetUrl: targetUrl,
      linkedEntityId: linkedEntityId,
      linkedEntityName: linkedEntityName,
      notes: notes,
      timeline: timeline,
    );
  }
}

class AdTimelineModel {
  final String label;
  final String date;
  final bool isCompleted;

  const AdTimelineModel({
    this.label = '',
    this.date = '',
    this.isCompleted = false,
  });

  factory AdTimelineModel.fromJson(Map<String, dynamic> json) {
    return AdTimelineModel(
      label: json['label'] ?? '',
      date: json['date'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
