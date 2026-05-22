class MediaModel {
  final String id;
  final int mediaType;
  final String fileName;
  final String? url;
  final String? type;

  MediaModel({
    required this.id,
    required this.mediaType,
    required this.fileName,
    this.url,
    this.type,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: (json['id'] ?? json['Id'] ?? '').toString(),
      mediaType: int.tryParse((json['mediaType'] ?? json['MediaType'] ?? 0).toString()) ?? 0,
      fileName: (json['fileName'] ?? json['FileName'] ?? '').toString(),
      url: json['url'] ?? json['Url'],
      type: json['type'] ?? json['Type'],
    );
  }
}
