import 'package:image_picker/image_picker.dart';

Future<String?> pickImageFromGallery({int imageQuality = 80}) async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: imageQuality,
  );
  return picked?.path;
}

Future<String?> pickImageFromCamera({int imageQuality = 80}) async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: imageQuality,
  );
  return picked?.path;
}
