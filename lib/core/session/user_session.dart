import 'package:doctory/core/common/models/role.dart';
import 'package:flutter/material.dart';
import '../cache/cache_helper.dart';
import '../cache/hive_service.dart';
import '../cache/secure_storage.dart';
import '../utils/general_constants.dart';
import '../locator/service_locator.dart';
import '../services/chat/chat_realtime_service.dart';

// TODO(dev): Resolve missing feature models or move them to core if they are shared
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

  /// Parsed role and permissions from the current user session
  static UserRole? currentRole;
  static Set<Permission>? currentPermissions;
  static DoctorEmploymentType? currentDoctorType;

  static MobileRole? get mobileRole {
    if (currentRole == null) return null;
    return MobileRole.from(
      role: currentRole!,
      doctorType: currentDoctorType,
    );
  }

  static bool can(Permission permission) {
    return currentPermissions?.contains(permission) ?? false;
  }

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

      if (response.containsKey("data") && response["data"] is Map) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(
          response["data"] as Map,
        );

        // Check if user is inside data, or if data is the user object itself
        if (data.containsKey("user") && data["user"] is Map) {
          userData = Map<String, dynamic>.from(data["user"] as Map);
        } else {
          // Based on API, user info (fullName, email, id) is directly inside 'data'
          userData = data;
        }
      } else if (response.containsKey("user") && response["user"] is Map) {
        userData = Map<String, dynamic>.from(response["user"] as Map);
      } else if (response.containsKey("id") || response.containsKey("email")) {
        userData = response;
      }

      if (userData.isNotEmpty) {
        userModel = userData;
        currentRole = UserRole.fromJson(userData['role']?.toString());
        currentDoctorType = DoctorEmploymentType.fromJson(
          userData['doctorType']?.toString(),
        );
        final rawPermissions = userData['permissions'] as List<dynamic>?;
        if (rawPermissions != null) {
          currentPermissions = rawPermissions
              .map((e) => Permission.fromJson(e?.toString()))
              .whereType<Permission>()
              .toSet();
        }
      }

      // Determine the token (accessToken, token, or access_token)
      if (response.containsKey("data") && response["data"] is Map) {
        final data = response["data"] as Map;
        if (data.containsKey("accessToken") && data["accessToken"] != null) {
          token = data["accessToken"].toString();
        } else if (data.containsKey("token") && data["token"] != null) {
          token = data["token"].toString();
        } else if (data.containsKey("access_token") &&
            data["access_token"] != null) {
          token = data["access_token"].toString();
        }
      } else if (response.containsKey("accessToken") &&
          response["accessToken"] != null) {
        token = response["accessToken"].toString();
      } else if (response.containsKey("token") && response["token"] != null) {
        token = response["token"].toString();
      } else if (response.containsKey("access_token") &&
          response["access_token"] != null) {
        token = response["access_token"].toString();
      }

      // Determine the refresh token
      if (response.containsKey("data") && response["data"] is Map) {
        final data = response["data"] as Map;
        if (data.containsKey("refreshToken") && data["refreshToken"] != null) {
          refreshToken = data["refreshToken"].toString();
        }
      } else if (response.containsKey("refreshToken") &&
          response["refreshToken"] != null) {
        refreshToken = response["refreshToken"].toString();
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
        await CacheHelper.saveBool('isLoggedIn', true);
      }

      userNotifier.value = userModel;
    } catch (e) {
      debugPrint("Error in saveUser: $e");
    }
  }

  /// Logout and clear session
  static Future<void> logout() async {
    // Disconnect Chat Realtime Service
    if (sl.isRegistered<ChatRealtimeService>()) {
      await sl<ChatRealtimeService>().disconnect();
    }
    token = '';
    refreshToken = '';
    userModel = null;
    currentRole = null;
    currentPermissions = null;
    currentDoctorType = null;
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
        currentRole = UserRole.fromJson(userData['role']?.toString());
        currentDoctorType = DoctorEmploymentType.fromJson(
          userData['doctorType']?.toString(),
        );
        final rawPermissions = userData['permissions'] as List<dynamic>?;
        if (rawPermissions != null) {
          currentPermissions = rawPermissions
              .map((e) => Permission.fromJson(e?.toString()))
              .whereType<Permission>()
              .toSet();
        }
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
      
      if (token.isNotEmpty) {
        // Intentionally empty — realtime init moved to chat cubits
      }

      return userModel;
    }
    return null;
  }
}
