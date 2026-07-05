class NotificationsEndpoints {
  static const String list = '/Notifications';
  static const String markRead = '/Notifications/{id}/read';
  static const String markAllRead = '/Notifications/read-all';
  static const String delete = '/Notifications/{id}';
  static const String deleteAll = '/Notifications/all';

  static String markReadById(int id) => '/Notifications/$id/read';
  static String deleteById(int id) => '/Notifications/$id';
}
