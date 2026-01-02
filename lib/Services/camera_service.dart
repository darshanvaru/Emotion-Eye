import 'package:camera/camera.dart';
import 'package:emotioneye/utilities/show_snack_bar.dart';
import 'package:flutter/cupertino.dart';

class CameraService {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;

  CameraController get cameraController {
    return _cameraController!;
  }

  Future<void> get initializeFuture {
    return _initializeControllerFuture!;
  }

  Future<void> initializeCamera(List<CameraDescription> cameras, int selectedIndex) async {
    _cameraController = CameraController(
      cameras[selectedIndex],
      ResolutionPreset.high,
    );

    try {
      _initializeControllerFuture = _cameraController!.initialize();
      await _initializeControllerFuture;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setFlashMode(BuildContext context, FlashMode mode) async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        await _cameraController!.setFlashMode(mode);
      } catch (e) {
        rethrow;
      }
    } else {
      showSnackBar(context, "FlashMode cannot be set. Camera not initialized yet");
    }
  }

  Future<XFile> capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      throw Exception('[CameraService] Cannot take picture. Camera not initialized.');
    }

    try {
      final file = await _cameraController!.takePicture();
      return file;
    } catch (e) {
      rethrow;
    }
  }

    Future<void> dispose() async {
      if (_cameraController != null) {
        if (_cameraController!.value.isInitialized) {
          await _cameraController!.dispose();
        }
        _cameraController = null;
      }
      _initializeControllerFuture = null;
    }
}
