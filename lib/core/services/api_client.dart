// import 'package:dams/core/services/consts.dart';
// import 'package:dams/core/utils/alerts.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:loading_overlay/loading_overlay.dart';
//  Future<void> uploadVideo({required String formField}) async {
//     try {
//       setState(() {
//         _isLoading = true;
//       });

//       FormData formData = FormData.fromMap({
//         "file": await MultipartFile.fromFile(formField, filename: "video.mp4"),
//       });

//       await dio.post(
//         Consts.devUrl,
//         data: formData,
//         options: Options(contentType: 'multipart/form-data'),
//       );

//       setState(() {
//         _isLoading = false;
//       });

//       Toaster('Video upload successful!');
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
      
//       Toaster('Error uploading video: $e');
//       if (kDebugMode) print('Error uploading video: $e');
//     }
//   }
