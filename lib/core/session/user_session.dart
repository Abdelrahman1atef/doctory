import 'package:flutter/material.dart';
import '../cache/cache_helper.dart';
import '../cache/hive_service.dart';
import '../cache/secure_storage.dart';
import '../utils/general_constants.dart';

// TODO: Resolve missing feature models or move them to core if they are shared
// import '../../features/auth/data/models/response/user_model.dart';
// import '../../features/splash/data/models/settings_model.dart';

/// Manages user session, authentication token, and persistence
class UserSession {
  UserSession._();

  /// User access token
  static String token = '';

  /// FCM Token for notifications
  static String fcmToken = '';

  /// Current user model (Using dynamic as feature models are missing)
  static dynamic userModel;
  static ValueNotifier<dynamic> userNotifier = ValueNotifier(null);

  /// Current user ID extracted from model
  static int? get userId {
    if (userModel == null) return null;
    if (userModel is Map) {
      return int.tryParse(userModel['id']?.toString() ?? '');
    }
    return null;
  }

  /// Guest mode flag
  static bool get isGuest => _isGuest;
  static bool _isGuest = false;
  static ValueNotifier<bool> guestNotifier = ValueNotifier(false);

  static void setGuest(bool value) {
    _isGuest = value;
    guestNotifier.value = value;
    // Trigger notification by re-assigning value (standard ValueNotifier practice)
    userNotifier.value = userNotifier.value;
  }

  /// Current settings data
  static dynamic settingsModel;

  static Future<void> saveUser(Map<String, dynamic> response) async {
    // Determine the user data map
    Map<String, dynamic> userData = {};
    if (response.containsKey("user")) {
      userData = Map<String, dynamic>.from(response["user"]);
    } else if (response.containsKey("data") &&
        response["data"] is Map &&
        response["data"].containsKey("user")) {
      userData = Map<String, dynamic>.from(response["data"]["user"]);
    } else if (response.containsKey("id") || response.containsKey("mobile")) {
      userData = response;
    }

    if (userData.isNotEmpty) {
      // userModel = UserModel.fromJson(userData);
      userModel = userData; // Fallback since model is missing
    }

    // Determine the token
    if (response.containsKey("token")) {
      token = response["token"].toString();
    } else if (response.containsKey("access_token")) {
      token = response["access_token"].toString();
    } else if (response.containsKey("data") && response["data"] is Map) {
      final data = response["data"] as Map;
      if (data.containsKey("token")) {
        token = data["token"]?.toString() ?? '';
      } else if (data.containsKey("access_token")) {
        token = data["access_token"]?.toString() ?? '';
      }
    }

    await HiveService().put(
      GeneralConstants.hiveUserBox,
      GeneralConstants.hiveUserKey,
      response,
    );

    if (token.isNotEmpty) {
      await SecureStorage.saveToken(token);
      // Ensure CacheHelper also knows we are logged in for IntroCubit
      await CacheHelper.saveBool('isLoggedIn', true);
    }

    // Update notifier last to trigger GoRouter redirect with correct token state
    userNotifier.value = userModel;
  }

  /// Logout and clear session
  static Future<void> logout() async {
    token = '';
    userModel = null;
    userNotifier.value = null;
    await HiveService().delete(
      GeneralConstants.hiveUserBox,
      GeneralConstants.hiveUserKey,
    );
    await SecureStorage.deleteToken();
    await CacheHelper.saveBool('isLoggedIn', false);
  }

  /// Get user data from Hive
  static Future<dynamic> getUser() async {
    final response = await HiveService().get(
      GeneralConstants.hiveUserBox,
      GeneralConstants.hiveUserKey,
    );

    var savedToken = await SecureStorage.getToken();

    // Migration logic: If no token in SecureStorage, check Hive (old way)
    if (savedToken == null) {
      final hiveToken = await HiveService().get(
        GeneralConstants.hiveUserBox,
        GeneralConstants.hiveAuthTokenKey,
      );
      if (hiveToken != null) {
        savedToken = hiveToken.toString();
        // Migrate to SecureStorage
        await SecureStorage.saveToken(savedToken);
        // Clean up Hive
        await HiveService().delete(
          GeneralConstants.hiveUserBox,
          GeneralConstants.hiveAuthTokenKey,
        );
      }
    }

    if (savedToken != null) {
      token = savedToken;
    }

    if (response != null && response is Map) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(response);

      Map<String, dynamic> userData = {};
      if (data.containsKey("user")) {
        userData = Map<String, dynamic>.from(data["user"]);
      } else if (data.containsKey("data") &&
          data["data"] is Map &&
          data["data"].containsKey("user")) {
        userData = Map<String, dynamic>.from(data["data"]["user"]);
      } else if (data.containsKey("id") || data.containsKey("mobile")) {
        userData = data;
      }

      if (userData.isNotEmpty) {
        // userModel = UserModel.fromJson(userData);
        userModel = userData; // Fallback
        userNotifier.value = userModel;
      }

      if (token.isEmpty) {
        if (data.containsKey("token")) {
          token = data["token"].toString();
        } else if (data.containsKey("access_token")) {
          token = data["access_token"].toString();
        } else if (data.containsKey("data") && data["data"] is Map) {
          final nestedData = data["data"] as Map;
          if (nestedData.containsKey("token")) {
            token = nestedData["token"].toString();
          } else if (nestedData.containsKey("access_token")) {
            token = nestedData["access_token"].toString();
          }
        }
      }
      return userModel;
    }
    return null;
  }
}
