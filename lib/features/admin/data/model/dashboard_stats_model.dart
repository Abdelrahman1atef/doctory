class AdminDashboardStats {
  final int totalVerifications;
  final int activeClinics;
  final int specializationsCount;
  final int totalUsers;
  final int openTickets;
  final int scheduledAds;
  final int expiredSubscriptions;

  const AdminDashboardStats({
    this.totalVerifications = 0,
    this.activeClinics = 0,
    this.specializationsCount = 0,
    this.totalUsers = 0,
    this.openTickets = 0,
    this.scheduledAds = 0,
    this.expiredSubscriptions = 0,
  });

  factory AdminDashboardStats.fromJson(Map<String, dynamic> json) {
    return AdminDashboardStats(
      totalVerifications: json['totalVerifications'] ?? 0,
      activeClinics: json['activeClinics'] ?? 0,
      specializationsCount: json['specializationsCount'] ?? 0,
      totalUsers: json['totalUsers'] ?? 0,
      openTickets: json['openTickets'] ?? 0,
      scheduledAds: json['scheduledAds'] ?? 0,
      expiredSubscriptions: json['expiredSubscriptions'] ?? 0,
    );
  }
}

class AdminTicketModel {
  final String code;
  final String subject;
  final String reporter;
  final String priority;
  final String date;

  const AdminTicketModel({
    this.code = '',
    this.subject = '',
    this.reporter = '',
    this.priority = '',
    this.date = '',
  });

  factory AdminTicketModel.fromJson(Map<String, dynamic> json) {
    return AdminTicketModel(
      code: json['code'] ?? '',
      subject: json['subject'] ?? '',
      reporter: json['reporter'] ?? '',
      priority: json['priority'] ?? '',
      date: json['date'] ?? '',
    );
  }
}

class AdminSubscriberModel {
  final String clinicName;
  final String startDate;
  final String endDate;
  final String package;
  final int doctorCount;
  final String status;

  const AdminSubscriberModel({
    this.clinicName = '',
    this.startDate = '',
    this.endDate = '',
    this.package = '',
    this.doctorCount = 0,
    this.status = '',
  });

  factory AdminSubscriberModel.fromJson(Map<String, dynamic> json) {
    return AdminSubscriberModel(
      clinicName: json['clinicName'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      package: json['package'] ?? '',
      doctorCount: json['doctorCount'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}

class AdminActivityModel {
  final String date;
  final String action;
  final String user;
  final String detail;

  const AdminActivityModel({
    this.date = '',
    this.action = '',
    this.user = '',
    this.detail = '',
  });

  factory AdminActivityModel.fromJson(Map<String, dynamic> json) {
    return AdminActivityModel(
      date: json['date'] ?? '',
      action: json['action'] ?? '',
      user: json['user'] ?? '',
      detail: json['detail'] ?? '',
    );
  }
}
