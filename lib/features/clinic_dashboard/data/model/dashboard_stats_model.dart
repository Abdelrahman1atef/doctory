class DashboardStatsModel {
  final int todayVisits;
  final double todayIncome;
  final int pendingActions;

  DashboardStatsModel({
    required this.todayVisits,
    required this.todayIncome,
    required this.pendingActions,
  });

  factory DashboardStatsModel.mock() {
    return DashboardStatsModel(
      todayVisits: 45,
      todayIncome: 1450.0,
      pendingActions: 3,
    );
  }

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      todayVisits: json['todayVisits'] as int,
      todayIncome: (json['todayIncome'] as num).toDouble(),
      pendingActions: json['pendingActions'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todayVisits': todayVisits,
      'todayIncome': todayIncome,
      'pendingActions': pendingActions,
    };
  }
}
