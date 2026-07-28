import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

typedef DeepLinkHandler = bool Function(Uri uri);

class DeepLinkService {
  DeepLinkService._();
  static final DeepLinkService instance = DeepLinkService._();

  final List<DeepLinkHandler> _handlers = [];
  String? _pendingPath;

  /// A GoRouter path to navigate to after authentication succeeds.
  /// Set by deep link handlers before navigating.
  String? get pendingPath => _pendingPath;

  void setPendingPath(String path) {
    _pendingPath = path;
  }

  /// Returns the pending path and clears it.
  String? consumePendingPath() {
    final path = _pendingPath;
    _pendingPath = null;
    return path;
  }

  void init() {
    try {
      final appLinks = AppLinks();
      appLinks.uriLinkStream.listen(_dispatch);
      appLinks.getInitialLink().then((uri) {
        if (uri != null) _dispatch(uri);
      });
    } catch (e) {
      debugPrint('DeepLinkService: $e');
    }
  }

  void register(DeepLinkHandler handler) {
    _handlers.add(handler);
  }

  void dispatch(Uri uri) {
    _dispatch(uri);
  }

  void _dispatch(Uri uri) {
    for (final handler in _handlers) {
      if (handler(uri)) return;
    }
    debugPrint('DeepLinkService: unhandled URI: $uri');
  }
}
