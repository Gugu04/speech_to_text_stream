import 'package:permission_handler/permission_handler.dart';

extension StringExtension on String {
  String capitalize() =>
      "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
}

class Utils {
  static void permissionMicrophone() async {
    final permission = await Permission.microphone.request();
    switch (permission) {
      case PermissionStatus.granted:
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
    }
  }
}
