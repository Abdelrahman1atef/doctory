import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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
      '793203157030-1aekjuvf8044duj2drh5f4r8slvc5ari.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: _serverClientId.isEmpty ? null : _serverClientId,
  );

  Future<SocialAuthResult?> signInWithGoogle() async {
    try {
      debugPrint('===> Starting Google Sign In...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint('===> Google Sign In Cancelled by user');
        return null;
      }

      debugPrint('===> Google User: ${googleUser.email}');
      debugPrint('===> Google Display Name: ${googleUser.displayName}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      debugPrint('===> Google AccessToken: ${googleAuth.accessToken}');
      debugPrint('===> Google IdToken: ${googleAuth.idToken}');

      final result = SocialAuthResult(
        name: googleUser.displayName,
        email: googleUser.email,
        // For Google, we often send idToken to the backend instead of accessToken
        accessToken: googleAuth.idToken ?? googleAuth.accessToken ?? '',
        idToken: googleAuth.idToken,
        provider: 'google',
      );

      debugPrint('===> Final Result: $result');
      return result;
    } catch (e) {
      debugPrint('===> Google Sign In Error: $e');
      return null;
    }
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
