import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<bool> requestPermission() async {
    Map<Permission, PermissionStatus> permission =
        await [Permission.photos, Permission.storage].request();


    if (!await Permission.photos.isGranted) {
      openAppSettings();
      return false;
    }

    if (!await Permission.storage.isGranted) {
      openAppSettings();
      return false;
    }
    return true;
  }
}
