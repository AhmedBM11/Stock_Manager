import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

Future<void> pickImage(TextEditingController controller) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    controller.text = pickedFile.path;
  } else {
    debugPrint("No image selected.");
  }
}
