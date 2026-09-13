import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'crashlytics_service.dart';

class SocialAuthResult {
  final String? name;
  final String? email;
  final String accessToken;
  final String? idToken;
  final String provider;

  SocialAuthResult({
    this.name,
    this.email,
    required this.accessToken,
    this.idToken,
    required this.provider,
  });

  @override
  String toString() {
    return 'SocialAuthResult(provider: $provider, name: $name, email: $email, token: ${accessToken.substring(0, accessToken.length > 10 ? 10 : accessToken.length)}...)';
  }
}

class SocialAuthService {
  static const String _serverClientId =
      '1077893614286-hfio622ah8p9hc0d97ms3h8e2lpmm88h.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: _serverClientId,
    scopes: ['email'],
  );

  Future<SocialAuthResult?> signInWithGoogle() async {
    try {
      debugPrint('===> Google Sign In: starting (serverClientId=$_serverClientId)');
      final user = await _googleSignIn.signIn();
      if (user == null) {
        // User dismissed the account picker — not an error.
        debugPrint('===> Google Sign In: cancelled by user');
        return null;
      }

      final auth = await user.authentication;
      debugPrint(
        '===> Google Sign In: account=${user.email} '
        'idToken=${auth.idToken != null} accessToken=${auth.accessToken != null}',
      );

      if (auth.idToken == null) {
        throw StateError(
          'Google returned no idToken (serverClientId missing or wrong OAuth client)',
        );
      }

      return SocialAuthResult(
        name: user.displayName,
        email: user.email,
        accessToken: auth.accessToken ?? '',
        idToken: auth.idToken,
        provider: 'google',
      );
    } on PlatformException catch (e, st) {
      // The native plugin surfaces Play Services failures here.
      // code 'sign_in_failed' + "ApiException: 10" == DEVELOPER_ERROR
      // (SHA-1 of the signing key not registered in Firebase / OAuth client).
      _reportGoogleError(
        'PlatformException code=${e.code} message=${e.message} details=${e.details}',
        e,
        st,
      );
      return null;
    } catch (e, st) {
      _reportGoogleError('$e', e, st);
      return null;
    }
  }

  void _reportGoogleError(String summary, Object error, StackTrace st) {
    debugPrint('===> Google Sign In Error: $summary');
    CrashlyticsService.log('Google Sign In Error: $summary');
    CrashlyticsService.recordError(error, st);
  }

  Future<SocialAuthResult?> signInWithFacebook() async {
    try {
      debugPrint('===> Starting Facebook Sign In...');
      final LoginResult result = await FacebookAuth.instance.login();

      debugPrint('===> Facebook Status: ${result.status}');
      debugPrint('===> Facebook Message: ${result.message}');

      if (result.status == LoginStatus.success) {
        debugPrint('===> Facebook Token: ${result.accessToken?.tokenString}');

        final userData = await FacebookAuth.instance.getUserData();
        debugPrint('===> Facebook User Data: $userData');

        final socialResult = SocialAuthResult(
          name: userData['name'],
          email: userData['email'],
          accessToken: result.accessToken?.tokenString ?? '',
          provider: 'facebook',
          idToken: '',
        );

        debugPrint('===> Final Result: $socialResult');
        return socialResult;
      } else {
        debugPrint('===> Facebook Login Failed or Cancelled');
      }
      return null;
    } catch (e) {
      debugPrint('===> Facebook Sign In Error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    debugPrint('===> Social Auth Sign Out');
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
  }
}
