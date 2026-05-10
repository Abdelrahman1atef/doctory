import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerGenerator {
  static final Map<String, BitmapDescriptor> _cache = {};

  static void clearCache() => _cache.clear();

  static Future<BitmapDescriptor> createCustomMarkerBitmap(
    String title, {
    bool isSelected = false,
    bool isRegistered = true,
  }) async {
    final String cacheKey = '${title}_${isSelected}_$isRegistered';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    const int size = 40; // Scaled down for better map proportions
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Premium Color Palette
    // Registered: Stitch Primary (0xFF076453)
    // Unregistered: Greyish (Stitch Secondary)
    // Selected: Vibrant Green or Highlight
    final Color markerColor = isSelected
        ? const Color(0xFF178229)
        : (isRegistered ? const Color(0xFF076453) : const Color(0xFF2196F3));
    final Color shadowColor = Colors.black.withValues(alpha: 0.3);

    // 1. Draw Shadow
    final Paint shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(
      const Offset(size / 2, (size / 2) + 4),
      (size / 2) - 6,
      shadowPaint,
    );

    // 2. Draw Main Circle
    final Paint circlePaint = Paint()..color = markerColor;
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      (size / 2) - 6,
      circlePaint,
    );

    // 3. Draw White Border
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      (size / 2) - 6,
      borderPaint,
    );

    // 4. Draw Inner Gradient/Highlight for premium 3D look
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

    // 5. Draw Text (First Letter)
    final String letter = title.isNotEmpty
        ? title.trim().substring(0, 1).toUpperCase()
        : 'C';
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: letter,
      style: TextStyle(
        fontSize: size * 0.45,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily:
            'Inter', // Try to use a clean font if available, fallback to default
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
    final bitmap = BitmapDescriptor.bytes(data!.buffer.asUint8List());
    
    _cache[cacheKey] = bitmap;
    return bitmap;
  }
}
