import 'package:dams/core/services/consts.dart';
import 'package:dams/core/utils/alerts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Future<void> uploadVideo({required var formField}) async {
  
  Dio dio = Dio();
  FormData formData = FormData.fromMap({"file": await MultipartFile.fromFile(formField, filename: "video.mp4")});

  try {
    Response response = await dio.post(
      Consts.devUrl,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    if (response.statusCode == 200) {
      Alerts('Video upload successful!');
    } else {
      Alerts(response.statusMessage.toString());
      if (kDebugMode) print('Video upload failed with status code: ${response.toString()}');
    }
  } catch (e) {
      Alerts(e.toString());
      if (kDebugMode) print('Error uploading video: $e');
  }
}
