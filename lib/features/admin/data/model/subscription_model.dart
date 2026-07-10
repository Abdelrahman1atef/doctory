class AdminSubscriptionModel {
  final String id;
  final String name;
  final String duration;
  final double price;
  final String currency;
  final String badge;
  final String cssClass;
  final List<String> features;
  final bool isActive;

  const AdminSubscriptionModel({
    required this.id,
    required this.name,
    this.duration = '',
    this.price = 0,
    this.currency = 'SAR',
    this.badge = '',
    this.cssClass = '',
    this.features = const [],
    this.isActive = true,
  });

  factory AdminSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return AdminSubscriptionModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      duration: json['duration'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'SAR',
      badge: json['badge'] ?? '',
      cssClass: json['cssClass'] ?? '',
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'duration': duration,
    'price': price,
    'currency': currency,
    'badge': badge,
    'cssClass': cssClass,
    'features': features,
    'isActive': isActive,
  };

  AdminSubscriptionModel copyWith({
    String? id,
    String? name,
    String? duration,
    double? price,
    String? currency,
    String? badge,
    String? cssClass,
    List<String>? features,
    bool? isActive,
  }) {
    return AdminSubscriptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      badge: badge ?? this.badge,
      cssClass: cssClass ?? this.cssClass,
      features: features ?? this.features,
      isActive: isActive ?? this.isActive,
    );
  }
}
