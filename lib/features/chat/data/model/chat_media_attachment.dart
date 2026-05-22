import 'dart:io';

class ChatMediaAttachment {
  final File file;
  final int mediaType; // 0=Image, 1=Video, 2=Audio, 3=Document
  final int place; // 9=Image, 10=Video, 12=Audio, 11=Document

  ChatMediaAttachment({required this.file, required this.mediaType, required this.place});

  static ChatMediaAttachment image(File file) => ChatMediaAttachment(file: file, mediaType: 0, place: 9);
  static ChatMediaAttachment video(File file) => ChatMediaAttachment(file: file, mediaType: 1, place: 10);
  static ChatMediaAttachment audio(File file) => ChatMediaAttachment(file: file, mediaType: 2, place: 12);
  static ChatMediaAttachment document(File file) => ChatMediaAttachment(file: file, mediaType: 3, place: 11);
}
