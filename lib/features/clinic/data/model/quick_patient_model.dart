class QuickPatientModel {
  final int id;
  final String name;
  final String phone;
  final String lastVisit;

  QuickPatientModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.lastVisit,
  });

  static List<QuickPatientModel> mockList() {
    return [
      QuickPatientModel(
        id: 1,
        name: 'Uzair bin Mohammed',
        phone: '0551234567',
        lastVisit: '2026-06-28',
      ),
      QuickPatientModel(
        id: 2,
        name: 'Haris Abdul Karim',
        phone: '0552345678',
        lastVisit: '2026-07-01',
      ),
      QuickPatientModel(
        id: 3,
        name: 'Hamza Al-Rifai',
        phone: '0553456789',
        lastVisit: '2026-07-02',
      ),
      QuickPatientModel(
        id: 4,
        name: 'Sarah Ahmed',
        phone: '0554567890',
        lastVisit: '2026-07-03',
      ),
    ];
  }

  factory QuickPatientModel.fromJson(Map<String, dynamic> json) {
    return QuickPatientModel(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      lastVisit: json['lastVisit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'lastVisit': lastVisit,
    };
  }
}
