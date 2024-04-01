// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:dams/core/theme/colors.dart';
import 'package:dams/core/theme/theme_extension.dart';
import 'package:dams/core/utils/alerts.dart';
import 'package:dams/core/utils/loader.dart';
import 'package:dams/core/utils/logger.dart';
import 'package:dams/core/utils/picker.dart';
import 'package:dams/core/utils/tap_effect.dart';
import 'package:dams/features/home/view/video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toast/toast.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var videoThumbnail;
  late File? videoPath;
  late Subscription _subscription;
  late MediaInfo? mediaInfo;

  late double videoSize = 0.0;
  late double compressedSize = 0.0;

  @override
  void initState() {
    _subscription = VideoCompress.compressProgress$.subscribe((progress) => context.loaderOverlay.show(widgetBuilder: 
      (progressas) =>  AppLoader(progress: progress.toString().substring(0,2),titleAction: 'Optimizing video')));
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
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayColor: AppColors.white,
      child: Scaffold(
        appBar: AppBar(title: const Text('DAMS.'), centerTitle: true),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => pickVideo(),
                child: Center(
                  child: videoThumbnail != null && videoThumbnail!.isNotEmpty
                  ? Container(
                    decoration: Theme.of(context).containerDecoration,
                    child:Image.memory(videoThumbnail!,fit: BoxFit.contain)
                  ) : Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 500,
                    decoration: Theme.of(context).containerDecoration,
                    child:  const Column(
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
              videoSize == 0.0 ? const SizedBox() : Text("Original Video Size: ${videoSize.toStringAsFixed(2)} MB"),
              const SizedBox(height: 16),
              compressedSize == 0.0 ? const SizedBox() : Text("Compressed Video Size: ${compressedSize.toStringAsFixed(2)} MB"),
            ],
          ),
        ),

        bottomSheet:  videoThumbnail != null && videoThumbnail!.isNotEmpty
          ? Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TapEffect(
                  onClick: () {
                    if (mediaInfo != null && mediaInfo!.file != null) {
                      String filePath = mediaInfo!.file!.path;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(videoPath: filePath)),
                      );
                    } else {
                      Toaster('Something went wrong, please try later!!');
                    }
                  },
                  child: Container(
                    width: 350,
                    height: 45,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: AppColors.primary),
                    child: const Center(child: Text('view compressed video',style: TextStyle(color: Colors.white))),
                  ),
                ),
                SizedBox.fromSize(size: const Size.fromHeight(10)),
                TapEffect(
                  onClick: () {},
                  child: Container(
                    width: 350,
                    height: 45,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: AppColors.secandry),
                    child: const Center(child: Text('upload',style: TextStyle(color: Colors.white))),
                  ),
                ),
            ],
          ),
        ) : const SizedBox(),
      ),
    );
  }

  void pickVideo() async {
    context.loaderOverlay.show(widgetBuilder: (progress) => const AppLoader(titleAction: 'Pick up video',));
    videoPath = await Picker.pickVideo(ImageSource.gallery);
    context.loaderOverlay.hide();
    
    if (kDebugMode) print(videoPath);
    double fileSize = await getFileSize(videoPath!.path);
    setState(() => videoSize = fileSize);
    if (kDebugMode) print('Original Video File size: $fileSize bytes');
    if (videoPath != null) {
      try {
        final compressResult = await VideoCompress.compressVideo(videoPath!.path, quality: VideoQuality.DefaultQuality, deleteOrigin: false);
        double fileSize = await getFileSize(compressResult!.file!.path);
        setState(() => compressedSize = fileSize);
        if (kDebugMode) print('Compressed Video File size: $fileSize bytes');
      
        final result = await VideoThumbnail.thumbnailData(video: videoPath!.path, imageFormat: ImageFormat.WEBP, maxWidth: 128, quality: 85);
     
        setState(() => videoThumbnail = result);
        if (kDebugMode) print(videoThumbnail);
        setState(() => mediaInfo = compressResult);    
    } catch (e) {
      context.loaderOverlay.hide();
      if (kDebugMode) print('Error generating video thumbnail: $e');
      Toaster(e.toString());
    }
  }
  context.loaderOverlay.hide();
  }
}
