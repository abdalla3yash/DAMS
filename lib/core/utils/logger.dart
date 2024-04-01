import 'dart:io';

Future<double> getFileSize(String filePath) async {
  File file = File(filePath);
  int sizeInBytes = await file.length();
  double sizeInMB = sizeInBytes / (1024 * 1024);
  return sizeInMB;
}
