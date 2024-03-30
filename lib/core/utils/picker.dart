import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'alerts.dart';

class Picker {
  static Future<File?> pickVideo(ImageSource imageSource) async {
    try {
      XFile? image = await ImagePicker().pickImage(source: imageSource, imageQuality: 50);
      return image != null ? File(image.path) : null;
    } on PlatformException catch (e) {
      Alerts(e.toString());
      return null;
    }
  }
}
