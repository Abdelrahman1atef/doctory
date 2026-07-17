class DashboardStatsModel {
  final int todayVisits;
  final double todayIncome;
  final int weeklyVisits;
  final double weeklyIncome;
  final int monthlyVisits;
  final double monthlyIncome;
  final int yearlyVisits;
  final double yearlyIncome;
  final int pendingActions;

  DashboardStatsModel({
    required this.todayVisits,
    required this.todayIncome,
    required this.weeklyVisits,
    required this.weeklyIncome,
    required this.monthlyVisits,
    required this.monthlyIncome,
    required this.yearlyVisits,
    required this.yearlyIncome,
    required this.pendingActions,
  });

  factory DashboardStatsModel.mock() {
    return DashboardStatsModel(
      todayVisits: 45,
      todayIncome: 1450.0,
      weeklyVisits: 280,
      weeklyIncome: 8500.0,
      monthlyVisits: 1200,
      monthlyIncome: 36000.0,
      yearlyVisits: 15400,
      yearlyIncome: 468000.0,
      pendingActions: 5,
    );
  }

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      todayVisits: json['todayVisits'] as int,
      todayIncome: (json['todayIncome'] as num).toDouble(),
      weeklyVisits: json['weeklyVisits'] as int,
      weeklyIncome: (json['weeklyIncome'] as num).toDouble(),
      monthlyVisits: json['monthlyVisits'] as int,
      monthlyIncome: (json['monthlyIncome'] as num).toDouble(),
      yearlyVisits: json['yearlyVisits'] as int,
      yearlyIncome: (json['yearlyIncome'] as num).toDouble(),
      pendingActions: json['pendingActions'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todayVisits': todayVisits,
      'todayIncome': todayIncome,
      'weeklyVisits': weeklyVisits,
      'weeklyIncome': weeklyIncome,
      'monthlyVisits': monthlyVisits,
      'monthlyIncome': monthlyIncome,
      'yearlyVisits': yearlyVisits,
      'yearlyIncome': yearlyIncome,
      'pendingActions': pendingActions,
    };
  }
}
