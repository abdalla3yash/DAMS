import 'dart:io';

import 'package:dams/core/utils/alerts.dart';
import 'package:dams/core/utils/permissions.dart';
import 'package:dams/core/utils/picker.dart';
import 'package:dams/core/utils/tap_effect.dart';
import 'package:dams/features/home/view/video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:dio/dio.dart';
import 'package:loading_overlay/loading_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var videoThumbnail;
  late File? videoPath;
  final Dio dio = Dio();
  late Subscription _subscription;
  late MediaInfo? mediaInfo;
  @override
  void initState() {
    requestPermissions(context);
    _subscription = VideoCompress.compressProgress$.subscribe((progress) {
      debugPrint('progress: $progress');
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(title: const Text('DAMS.'), centerTitle: true),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                videoPath = await Picker.pickVideo(ImageSource.gallery);
                print(videoPath);
                double fileSize = await getFileSize(videoPath!.path);
                print('File size: $fileSize bytes');

                mediaInfo = await VideoCompress.compressVideo(
                  videoPath!.path,
                  quality: VideoQuality.DefaultQuality,
                  deleteOrigin: false,
                ).then((value) async {
                  if (videoPath != null) {
                    try {
                      final thumbnailPath = await VideoThumbnail.thumbnailData(
                        video: videoPath!.path,
                        imageFormat: ImageFormat.WEBP,
                        maxWidth: 128,
                        quality: 85,
                      );
                      print('sadasd');
                      print(thumbnailPath);

                      setState(() {
                        videoThumbnail = thumbnailPath;
                      });
                    } catch (e) {
                      print('Err/or generating video thumbnail: $e');
                      // Handle error, show a message to the user, or retry thumbnail generation
                    }
                  }
                });
              },
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 500,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(16)),
                  child: videoThumbnail != null && videoThumbnail!.isNotEmpty
                      ? Image.memory(videoThumbnail)
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Spacer(flex: 2),
                            Icon(Icons.video_collection_sharp),
                            Spacer(),
                            Text('Upload Your Ultimate Data'),
                            Spacer(),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            videoThumbnail != null && videoThumbnail!.isNotEmpty
                ? TapEffect(
                    // onClick: () async => await uploadVideo(formField: videoPath!.path),
                    onClick: () {
                      // Initialize a VideoPlayerController with the thumbnail file
                      VideoPlayerController controller = VideoPlayerController.file(mediaInfo!.path as File);

                      print("this is video controller ${controller.dataSource}");

                      // Navigate to the video player screen and pass the controller
                      Navigator.push(context,MaterialPageRoute(builder: (context) => videoPlayer(controller: controller)));
                    },
                    child: Container(
                      width: 350,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.blue),
                      child: const Center(
                        child: Text(
                          'Upload',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

Future<double> getFileSize(String filePath) async {
  File file = File(filePath);
  int sizeInBytes = await file.length();
  double sizeInMB = sizeInBytes / (1024 * 1024);
  return sizeInMB;
}
