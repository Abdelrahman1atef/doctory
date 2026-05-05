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

  /// Refresh token
  static String refreshToken = '';

  /// FCM Token for notifications
  static String fcmToken = '';

  /// Current user model (Using dynamic as feature models are missing)
  static dynamic userModel;
  static ValueNotifier<dynamic> userNotifier = ValueNotifier(null);

  /// Current user ID extracted from model
  static String? get userId {
    if (userModel == null) return null;
    if (userModel is Map) {
      return userModel['id']?.toString();
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
    try {
      // Determine the user data map
      Map<String, dynamic> userData = {};
      if (response.containsKey("user") && response["user"] is Map) {
        userData = Map<String, dynamic>.from(response["user"] as Map);
      } else if (response.containsKey("data") &&
          response["data"] is Map &&
          (response["data"] as Map).containsKey("user") &&
          (response["data"] as Map)["user"] is Map) {
        userData = Map<String, dynamic>.from(
          (response["data"] as Map)["user"] as Map,
        );
      } else if (response.containsKey("id") || response.containsKey("email")) {
        userData = response;
      }

      if (userData.isNotEmpty) {
        userModel = userData;
      }

      // Determine the token (accessToken, token, or access_token)
      if (response.containsKey("accessToken") &&
          response["accessToken"] != null) {
        token = response["accessToken"].toString();
      } else if (response.containsKey("token") && response["token"] != null) {
        token = response["token"].toString();
      } else if (response.containsKey("access_token") &&
          response["access_token"] != null) {
        token = response["access_token"].toString();
      } else if (response.containsKey("data") && response["data"] is Map) {
        final data = response["data"] as Map;
        if (data.containsKey("accessToken") && data["accessToken"] != null) {
          token = data["accessToken"]?.toString() ?? '';
        } else if (data.containsKey("token") && data["token"] != null) {
          token = data["token"]?.toString() ?? '';
        } else if (data.containsKey("access_token") &&
            data["access_token"] != null) {
          token = data["access_token"]?.toString() ?? '';
        }
      }

      // Determine the refresh token
      if (response.containsKey("refreshToken") &&
          response["refreshToken"] != null) {
        refreshToken = response["refreshToken"].toString();
      } else if (response.containsKey("data") && response["data"] is Map) {
        final data = response["data"] as Map;
        if (data.containsKey("refreshToken") && data["refreshToken"] != null) {
          refreshToken = data["refreshToken"]?.toString() ?? '';
        }
      }

      await HiveService().put(
        GeneralConstants.hiveUserBox,
        GeneralConstants.hiveUserKey,
        response,
      );

      if (token.isNotEmpty) {
        await SecureStorage.saveToken(token);
        if (refreshToken.isNotEmpty) {
          await SecureStorage.saveRefreshToken(refreshToken);
        }
        // Ensure CacheHelper also knows we are logged in for IntroCubit
        await CacheHelper.saveBool('isLoggedIn', true);
      }

      // Update notifier last to trigger GoRouter redirect with correct token state
      userNotifier.value = userModel;
    } catch (e) {
      debugPrint("Error in saveUser: $e");
    }
  }

  /// Logout and clear session
  static Future<void> logout() async {
    token = '';
    refreshToken = '';
    userModel = null;
    userNotifier.value = null;
    await HiveService().delete(
      GeneralConstants.hiveUserBox,
      GeneralConstants.hiveUserKey,
    );
    await SecureStorage.clearAuthData();
    await CacheHelper.saveBool('isLoggedIn', false);
  }

  /// Get user data from Hive
  static Future<dynamic> getUser() async {
    final response = await HiveService().get(
      GeneralConstants.hiveUserBox,
      GeneralConstants.hiveUserKey,
    );

    var savedToken = await SecureStorage.getToken();
    var savedRefreshToken = await SecureStorage.getRefreshToken();

    if (savedToken != null) {
      token = savedToken;
    }
    if (savedRefreshToken != null) {
      refreshToken = savedRefreshToken;
    }

    if (response != null && response is Map) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(response);

      Map<String, dynamic> userData = {};
      if (data.containsKey("user") && data["user"] != null) {
        userData = Map<String, dynamic>.from(data["user"] as Map);
      } else if (data.containsKey("data") &&
          data["data"] is Map &&
          (data["data"] as Map).containsKey("user") &&
          (data["data"] as Map)["user"] != null) {
        userData = Map<String, dynamic>.from(
          (data["data"] as Map)["user"] as Map,
        );
      } else if (data.containsKey("id") || data.containsKey("email")) {
        userData = data;
      }

      if (userData.isNotEmpty) {
        userModel = userData;
        userNotifier.value = userModel;
      }

      if (token.isEmpty) {
        if (data.containsKey("accessToken")) {
          token = data["accessToken"].toString();
        } else if (data.containsKey("token")) {
          token = data["token"].toString();
        } else if (data.containsKey("access_token")) {
          token = data["access_token"].toString();
        } else if (data.containsKey("data") && data["data"] is Map) {
          final nestedData = data["data"] as Map;
          if (nestedData.containsKey("accessToken")) {
            token = nestedData["accessToken"].toString();
          } else if (nestedData.containsKey("token")) {
            token = nestedData["token"].toString();
          } else if (nestedData.containsKey("access_token")) {
            token = nestedData["access_token"].toString();
          }
        }
      }

      if (refreshToken.isEmpty) {
        if (data.containsKey("refreshToken")) {
          refreshToken = data["refreshToken"].toString();
        } else if (data.containsKey("data") && data["data"] is Map) {
          final nestedData = data["data"] as Map;
          if (nestedData.containsKey("refreshToken")) {
            refreshToken = nestedData["refreshToken"].toString();
          }
        }
      }
      return userModel;
    }
    return null;
  }
}
