import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Service responsible for compressing media files before upload.
///
/// - Images: compressed to stay under [maxImageSizeBytes] (default 10 MB).
/// - Videos: compressed using medium quality to reduce size before upload.
///
/// The server stores the compressed version. When fetched, the client
/// displays it at full resolution (no client-side down-scaling on display).
class MediaCompressionService {
  /// 10 MB limit for images
  static const int maxImageSizeBytes = 10 * 1024 * 1024;

  /// 10 GB limit for videos (after compression)
  static const int maxVideoSizeBytes = 10 * 1024 * 1024 * 1024;

  // ─────────────────────────── Images ───────────────────────────

  /// Compress a single image file.
  ///
  /// Strategy:
  /// 1. If the file is already under [maxImageSizeBytes] at quality 85,
  ///    return it directly.
  /// 2. Otherwise progressively lower quality until it fits.
  /// 3. Returns the compressed [File].
  static Future<File> compressImage(File file) async {
    final originalSize = await file.length();

    // If already small enough, only do a light quality pass
    if (originalSize <= maxImageSizeBytes) {
      final result = await _compressImageWithQuality(file, quality: 85);
      return result;
    }

    // Progressive compression – start at 70 and step down
    for (int quality = 70; quality >= 20; quality -= 10) {
      final compressed = await _compressImageWithQuality(file, quality: quality);
      final compressedSize = await compressed.length();

      debugPrint(
        '[MediaCompress] Image quality=$quality '
        '| original=${_formatBytes(originalSize)} '
        '| compressed=${_formatBytes(compressedSize)}',
      );

      if (compressedSize <= maxImageSizeBytes) {
        return compressed;
      }
    }

    // Last resort: very aggressive compression
    return _compressImageWithQuality(file, quality: 10);
  }

  /// Compress a list of images and return the compressed files.
  static Future<List<File>> compressImages(List<File> files) async {
    return Future.wait(files.map(compressImage));
  }

  static Future<File> _compressImageWithQuality(
    File file, {
    required int quality,
  }) async {
    final dir = await getTemporaryDirectory();
    final targetPath = p.join(
      dir.path,
      'compressed_${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}',
    );

    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      keepExif: false,
    );

    if (result == null) return file;
    return File(result.path);
  }

  // ─────────────────────────── Videos ───────────────────────────

  /// Compress a video file using medium quality.
  ///
  /// [VideoQuality.MediumQuality] provides a good balance between
  /// visual fidelity and file size reduction.
  static Future<File> compressVideo(
    File file, {
    VideoQuality quality = VideoQuality.MediumQuality,
  }) async {
    final originalSize = await file.length();
    debugPrint(
      '[MediaCompress] Video original size: ${_formatBytes(originalSize)}',
    );

    final MediaInfo? info = await VideoCompress.compressVideo(
      file.path,
      quality: quality,
      deleteOrigin: false,
      includeAudio: true,
    );

    if (info == null || info.file == null) {
      debugPrint('[MediaCompress] Video compression failed, using original');
      return file;
    }

    final compressedSize = await info.file!.length();
    debugPrint(
      '[MediaCompress] Video compressed: ${_formatBytes(compressedSize)} '
      '(saved ${_formatBytes(originalSize - compressedSize)})',
    );

    // If compressed is larger than original (rare edge case), keep original
    if (compressedSize >= originalSize) {
      return file;
    }

    return info.file!;
  }

  // ─────────────────────────── Validation ───────────────────────

  /// Validate that an image file does not exceed the server limit.
  /// Returns `null` if valid, or an error message string.
  static Future<String?> validateImageSize(File file) async {
    final size = await file.length();
    if (size > maxImageSizeBytes) {
      return 'Image exceeds ${_formatBytes(maxImageSizeBytes)} limit '
          '(current: ${_formatBytes(size)})';
    }
    return null;
  }

  /// Validate that a video file does not exceed the server limit.
  /// Returns `null` if valid, or an error message string.
  static Future<String?> validateVideoSize(File file) async {
    final size = await file.length();
    if (size > maxVideoSizeBytes) {
      return 'Video exceeds ${_formatBytes(maxVideoSizeBytes)} limit '
          '(current: ${_formatBytes(size)})';
    }
    return null;
  }

  // ─────────────────────────── Helpers ───────────────────────────

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Cancel any on-going video compression (useful when user navigates away).
  static Future<void> cancelVideoCompression() async {
    await VideoCompress.cancelCompression();
  }
}
