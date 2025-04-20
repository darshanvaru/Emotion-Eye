import 'package:camera/camera.dart';

class CameraService {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;

  CameraController get cameraController => _cameraController!;
  Future<void> get initializeFuture => _initializeControllerFuture!;

  Future<void> initializeCamera(List<CameraDescription> cameras, int selectedIndex) async {
    _cameraController = CameraController(
      cameras[selectedIndex],
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _cameraController!.initialize();
    await _initializeControllerFuture;
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      await _cameraController!.setFlashMode(mode);
    }
  }

  Future<XFile> capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      throw Exception('Camera not initialized');
    }
    return _cameraController!.takePicture();
  }

  void dispose() {
    if (_cameraController != null) {
      if (_cameraController!.value.isInitialized) {
        _cameraController!.dispose();
      }
      _cameraController = null;
    }
    _initializeControllerFuture = null;
  }
}