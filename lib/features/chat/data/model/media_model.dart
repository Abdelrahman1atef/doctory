class MediaModel {
  final String id;
  final int mediaType;
  final String fileName;

  MediaModel({
    required this.id,
    required this.mediaType,
    required this.fileName,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: (json['id'] ?? '').toString(),
      mediaType: int.tryParse((json['mediaType'] ?? 0).toString()) ?? 0,
      fileName: (json['fileName'] ?? '').toString(),
    );
  }
}
