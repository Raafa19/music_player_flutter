import 'package:permission_handler/permission_handler.dart';

Future<bool> storagePermissions() async {
  if (await Permission.audio.isDenied) {
    await Permission.audio.request();
  }

  if (await Permission.manageExternalStorage.isDenied) {
    await Permission.manageExternalStorage.request();
  }

  return await checkPermissions();
}

Future<bool> checkPermissions() async {
  if (await Permission.audio.isGranted &&
      await Permission.manageExternalStorage.isGranted) {
    return true;
  }
  return false;
}
