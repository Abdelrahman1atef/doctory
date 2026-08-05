import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Immutable marker description. All fields are cross-isolate safe.
class MarkerSpec {
  final String id;
  final String title;
  final bool isSelected;
  final bool isRegistered;

  const MarkerSpec({
    required this.id,
    required this.title,
    this.isSelected = false,
    this.isRegistered = true,
  });
}

/// Result of rendering one marker in a background isolate.
class MarkerResult {
  final MarkerSpec spec;
  final Uint8List bytes;

  const MarkerResult(this.spec, this.bytes);
}

class MarkerGenerator {
  /// Bounded cache — prevents unbounded native bitmap growth on low-RAM
  /// devices across repeated searches.
  static const int maxCacheEntries = 60;
  static final Map<String, BitmapDescriptor> _cache = {};
  static final List<String> _cacheKeys = [];

  static void clearCache() {
    _cache.clear();
    _cacheKeys.clear();
  }

  /// Renders all markers off the UI thread and returns
  /// markerId -> BitmapDescriptor. The UI isolate never does CPU-heavy
  /// PNG encoding, which keeps taps/navigation smooth on mid-range phones.
  static Future<Map<String, BitmapDescriptor>> generateMarkers(
    List<MarkerSpec> specs,
  ) => _transformPair(specs);

  static Future<Map<String, BitmapDescriptor>> _transformPair(
    List<MarkerSpec> specs,
  ) async {
    final result = <String, BitmapDescriptor>{};
    if (specs.isEmpty) return result;

    final byCacheKey = <String, MarkerSpec>{};
    for (final spec in specs) {
      final key = _cacheKeyOf(spec);
      final cached = _cache[key];
      if (cached != null) {
        result[spec.id] = cached;
      } else {
        byCacheKey[key] = spec;
      }
    }

    final toRender = byCacheKey.values.toList();
    if (toRender.isEmpty) return result;

    try {
      final generated = await compute(_renderMarkersInBackground, toRender);
      for (final item in generated) {
        _putCache(_cacheKeyOf(item.spec), BitmapDescriptor.bytes(item.bytes));
      }
    } catch (e) {
      debugPrint('Marker generation failed on isolate, falling back: $e');
      for (final spec in toRender) {
        try {
          final bytes = await _renderMarker(spec);
          if (bytes != null) {
            _putCache(_cacheKeyOf(spec), BitmapDescriptor.bytes(bytes));
          }
        } catch (_) {}
      }
    }

    for (final spec in toRender) {
      final cached = _cache[_cacheKeyOf(spec)];
      if (cached != null) {
        result[spec.id] = cached;
      }
    }
    return result;
  }

  static Future<List<MarkerResult>> _renderMarkersInBackground(
    List<MarkerSpec> specs,
  ) async {
    final outputs = <MarkerResult>[];
    for (final spec in specs) {
      final bytes = await _renderMarker(spec);
      if (bytes != null) {
        outputs.add(MarkerResult(spec, bytes));
      }
    }
    return outputs;
  }

  static Future<Uint8List?> _renderMarker(MarkerSpec spec) async {
    const int size = 40;
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Color markerColor = spec.isSelected
        ? const Color(0xFF178229)
        : (spec.isRegistered ? const Color(0xFF076453) : const Color(0xFF2196F3));
    final Color shadowColor = Colors.black.withValues(alpha: 0.3);

    final Paint shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(
      const Offset(size / 2, (size / 2) + 4),
      (size / 2) - 6,
      shadowPaint,
    );

    final Paint circlePaint = Paint()..color = markerColor;
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      (size / 2) - 6,
      circlePaint,
    );

    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      (size / 2) - 6,
      borderPaint,
    );

    final Paint highlightPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(size / 2, 6),
        const Offset(size / 2, size - 6),
        [Colors.white.withValues(alpha: 0.3), Colors.transparent],
      );
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      (size / 2) - 8,
      highlightPaint,
    );

    final String letter = _letterFrom(spec.title);
    final TextPainter painter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(
        text: letter,
        style: const TextStyle(
          fontSize: size * 0.45,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      );
    painter.layout();
    painter.paint(
      canvas,
      Offset(
        (size / 2) - (painter.width / 2),
        (size / 2) - (painter.height / 2),
      ),
    );

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    if (data == null) return null;
    return data.buffer.asUint8List();
  }

  static String _letterFrom(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return 'C';
    return trimmed.substring(0, 1).toUpperCase();
  }

  static String _cacheKeyOf(MarkerSpec spec) =>
      '${spec.title}_${spec.isSelected}_${spec.isRegistered}';

  static void _putCache(String key, BitmapDescriptor descriptor) {
    _cache[key] = descriptor;
    _cacheKeys.remove(key);
    _cacheKeys.add(key);
    while (_cacheKeys.length > maxCacheEntries) {
      final oldest = _cacheKeys.removeAt(0);
      _cache.remove(oldest);
    }
  }
}