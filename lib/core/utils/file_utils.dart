import 'dart:io';

/// Utilities for file-related operations
class FileUtils {
  FileUtils._();

  /// Get file size in MB
  static double getFileSizeInMB(File file) {
    final size = file.readAsBytesSync().lengthInBytes;
    final kb = size / 1024;
    final mb = kb / 1024;
    return mb;
  }

  /// Get file size in KB
  static double getFileSizeInKB(File file) {
    final size = file.readAsBytesSync().lengthInBytes;
    final kb = size / 1024;
    return kb;
  }
}
