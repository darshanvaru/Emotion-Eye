import 'package:flutter/services.dart';

class NativeCameraLauncher {
  static const platform = MethodChannel('com.darshan.emotioneye/camera');

  static Future<String?> openNativeCamera() async {
    try {
      await platform.invokeMethod('openCameraApp');
      return null;
    } on PlatformException {
      return 'Unable to open camera. Please try again.';
    } catch (_) {
      return 'Something went wrong. Please try again.';
    }
  }
}
