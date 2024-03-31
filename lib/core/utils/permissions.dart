import 'package:dams/core/utils/alerts.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions(context) async {
  await _requestPermission(context, Permission.photos, 'gallery');
  await _requestPermission(context, Permission.camera, 'camera');
}

Future<void> _requestPermission(context, Permission permission, String permissionName) async {
  PermissionStatus status = await permission.request();
  if (status.isDenied) {
    Alerts(context, permissionName.toString());
  }
}
