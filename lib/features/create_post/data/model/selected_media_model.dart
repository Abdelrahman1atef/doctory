import 'dart:io';

enum MediaType { image, video, audio, file }

class SelectedMediaModel {
  File file;
  final MediaType type;
  String? uploadedFileName;
  bool isCompressing;

  SelectedMediaModel({
    required this.file,
    required this.type,
    this.uploadedFileName,
    this.isCompressing = false,
  });
}
