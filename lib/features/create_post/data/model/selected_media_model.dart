import 'dart:io';

enum MediaType {
  image,
  video,
  audio,
  file,
}

class SelectedMediaModel {
  final File file;
  final MediaType type;
  String? uploadedFileName;

  SelectedMediaModel({
    required this.file,
    required this.type,
    this.uploadedFileName,
  });
}
