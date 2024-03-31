import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'alerts.dart';

class Picker {
  static Future<File?> pickVideo(ImageSource imageSource) async {
    try {
      XFile? video = await ImagePicker().pickVideo(source: imageSource,);
      return video != null ? File(video.path) : null;
    } on PlatformException catch (e) {
      Toaster(e.toString());
      return null;
    }
  }
}
