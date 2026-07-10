import 'service_locator.dart';
import '../../features/admin/di/admin_di.dart';

/// Easy setup function for service locator
/// Call this in main.dart before running the app
Future<void> setupLocator() async {
  await ServiceLocator.init();
  setupAdminLocator();
}

/// Quick access to service locator
/// Use this instead of importing GetIt directly
const locator = ServiceLocator;
