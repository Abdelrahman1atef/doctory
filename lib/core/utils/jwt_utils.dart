import 'dart:convert';

/// Minimal JWT helpers. Reads claims from an access token without verifying
/// the signature — the server stays the source of truth, this only lets the
/// client mirror what the token already asserts (e.g. the `ClinicId` claim).
abstract class JwtUtils {
  /// Decoded payload of [token], or an empty map when it is not a JWT.
  static Map<String, dynamic> payload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return const {};
    try {
      final decoded = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      return decoded is Map<String, dynamic> ? decoded : const {};
    } catch (_) {
      return const {};
    }
  }

  /// Value of the claim called [name], ignoring case, underscores and any
  /// URI namespace prefix — so `ClinicId`, `clinic_id` and
  /// `http://schemas.example/clinicid` all match `clinicId`.
  static String? claim(String token, String name) {
    final target = _normalize(name);
    for (final entry in payload(token).entries) {
      if (_normalize(entry.key) != target) continue;
      final value = entry.value?.toString() ?? '';
      return value.isEmpty ? null : value;
    }
    return null;
  }

  static String _normalize(String key) =>
      key.split('/').last.replaceAll('_', '').toLowerCase();
}
