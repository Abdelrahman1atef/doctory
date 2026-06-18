import 'dart:developer';
import 'dart:io';
import 'package:doctory/core/services/alerts.dart';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class FileOpenerService {
  static Future<void> openFile(String fileUrl) async {
    try {
      SmartDialog.showLoading(msg: "جاري التحميل...");
      final dio = Dio();
      final tempDir = await getTemporaryDirectory();
      final fileName = path.basename(fileUrl);
      final savePath = path.join(tempDir.path, fileName);

      final file = File(savePath);

      if (!await file.exists()) {
        await dio.download(fileUrl, savePath);
      }

      SmartDialog.dismiss();
      await OpenFilex.open(savePath);
    } catch (e) {
      SmartDialog.dismiss();
      Alerts.showToast("حدث خطأ أثناء فتح الملف");
      log('Error opening file: $e');
    }
  }
}
