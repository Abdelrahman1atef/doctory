class MediaModel {
  final String id;
  final String mediaType;
  final String fileName;

  MediaModel({
    required this.id,
    required this.mediaType,
    required this.fileName,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'] ?? '',
      mediaType: json['mediaType'] ?? 'Image',
      fileName: json['fileName'] ?? '',
    );
  }
}
