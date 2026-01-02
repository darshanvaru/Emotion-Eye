import 'dart:io';

import 'package:camera/camera.dart';
import 'package:emotioneye/Screens/result_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/camera_service.dart';
import '../services/image_processor_service.dart';
import '../utilities/show_snack_bar.dart';
import '../widgets/photo_clicked_widget.dart';
import '../widgets/camera_help_dialog.dart';

class MainCamera extends StatefulWidget {
  const MainCamera({super.key, this.isPhotoClicked = false});

  final bool isPhotoClicked;

  @override
  State<MainCamera> createState() => _MainCameraState();
}

class _MainCameraState extends State<MainCamera> with WidgetsBindingObserver {
  final CameraService _cameraService = CameraService();

  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  FlashMode _flashMode = FlashMode.auto;

  XFile? _capturedImage;
  bool _isProcessingImage = false;
  bool _photoClicked = false;

  bool _isCameraInitialized = false;
  bool _isInitializingCamera = false;
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _photoClicked = widget.isPhotoClicked;
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handlePermissionsFlow();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeCamera();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_permissionsGranted) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _disposeCamera();
    } else if (state == AppLifecycleState.resumed) {
      if (!_photoClicked) {
        _initializeCamera();
      }
    }
  }

  Future<void> _handlePermissionsFlow() async {
    final cameraStatus = await Permission.camera.status;
    final micStatus = await Permission.microphone.status;
    if (!mounted) return;

    if (cameraStatus.isGranted && micStatus.isGranted) {
      _permissionsGranted = true;
      _initializeCamera();
      return;
    }

    final bool shouldRequest = await _showPrePermissionDialog();
    if (!mounted) return;

    if (!shouldRequest) {
      Navigator.of(context).pop();
      showSnackBar(context, 'Camera permission denied.', isError: true);
      return;
    }

    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (!mounted) return;

    final cam = statuses[Permission.camera]!;
    final mic = statuses[Permission.microphone]!;

    if (cam.isGranted && mic.isGranted) {
      _permissionsGranted = true;
      _initializeCamera();
      return;
    }

    if (cam.isPermanentlyDenied || mic.isPermanentlyDenied) {
      showSnackBar(context, 'Camera or microphone permission permanently denied. Enable it from settings.', isError: true);
      await openAppSettings();
    }

    if (!mounted) return;
    Navigator.of(context).pop();
    showSnackBar(context, 'Camera permission denied.', isError: true);
  }

  Future<bool> _showPrePermissionDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Camera permission required'),
        content: const Text(
          'Camera and microphone access are required to capture photos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Allow'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _initializeCamera() async {
    if (_isInitializingCamera || _isCameraInitialized) return;

    _isInitializingCamera = true;

    try {
      _cameras = await availableCameras();
      if (!mounted) return;

      if (_cameras.isEmpty) {
        showSnackBar(context, 'No camera available', isError: true);
        return;
      }

      await _cameraService.initializeCamera(
        _cameras,
        _selectedCameraIndex,
      );
      if(mounted) {
        await _cameraService.setFlashMode(context, _flashMode);
      }

      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Camera initialization failed', isError: true);
      }
    } finally {
      _isInitializingCamera = false;
    }
  }

  Future<void> _disposeCamera() async {
    if (!_isCameraInitialized) return;

    await _cameraService.dispose();
    if (!mounted) return;

    setState(() {
      _isCameraInitialized = false;
    });
  }

  Future<void> _capturePhoto() async {
    if (!_isCameraInitialized || _isProcessingImage) return;

    setState(() => _isProcessingImage = true);

    try {
      final image = await _cameraService.capturePhoto();
      if (!mounted) return;

      final processed = (_selectedCameraIndex == 1)
          ? await flipImageHorizontally(image)
          : image;

      if (!mounted) return;

      setState(() {
        _capturedImage = processed;
        _photoClicked = true;
      });

      await _disposeCamera();
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Failed to capture photo', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessingImage = false);
      }
    }
  }

  Future<void> _pickFromGallery() async {
    await _disposeCamera();
    setState(() => _isProcessingImage = true);

    try {
      final picked =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      if (!mounted) return;

      if (picked == null) {
        showSnackBar(context, 'No image selected');
        setState(() => _photoClicked = false);
        return;
      }

      setState(() {
        _capturedImage = picked;
        _photoClicked = true;
      });
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Gallery error', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessingImage = false);
      }
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras.length <= 1) return;

    await _disposeCamera();
    _selectedCameraIndex =
        (_selectedCameraIndex + 1) % _cameras.length;
    _initializeCamera();
  }

  Future<void> _toggleFlash() async {
    if (!_isCameraInitialized) return;

    final next = _flashMode == FlashMode.auto
        ? FlashMode.torch
        : _flashMode == FlashMode.torch
        ? FlashMode.off
        : FlashMode.auto;

    try {
      await _cameraService.setFlashMode(context, next);
      if (!mounted) return;
      setState(() => _flashMode = next);
    } catch (_) {
      showSnackBar(context, 'Flash error', isError: true);
    }
  }

  Future<void> _analyzeEmotion() async {
    if (_capturedImage == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ResultPage(imageFile: XFile(_capturedImage!.path)),
      ),
    );

    if (!mounted) return;
    setState(() {
      _photoClicked = false;
      _capturedImage = null;
    });

    _initializeCamera();
  }

  void _togglePhotoClicked() {
    setState(() {
      _photoClicked = !_photoClicked;
      _capturedImage = null;
    });

    if (_photoClicked) {
      _disposeCamera();
    } else {
      _initializeCamera();
    }
  }

  Widget _buildCameraPreview() {
    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final size = MediaQuery.of(context).size;
    final scale = 1 /
        (_cameraService.cameraController.value.aspectRatio *
            (size.width / size.height));

    return Transform.scale(
      scale: scale,
      child: CameraPreview(_cameraService.cameraController),
    );
  }

  Widget _buildCapturedPreview() {
    return Center(
      child: Image.file(File(_capturedImage!.path)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(225, 0, 31, 84),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_isCameraInitialized && _selectedCameraIndex == 0)
            IconButton(
              icon: Icon(
                _flashMode == FlashMode.auto
                    ? Icons.flash_auto
                    : _flashMode == FlashMode.torch
                    ? Icons.flash_on
                    : Icons.flash_off,
              ),
              onPressed: _toggleFlash,
            ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const CameraHelpDialog(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _photoClicked && _capturedImage != null
                ? _buildCapturedPreview()
                : _buildCameraPreview(),
          ),
          SizedBox(
            height: 80,
            child: PhotoClickedWidget(
              photoClicked: _photoClicked,
              togglePhotoClicked: _togglePhotoClicked,
              capturePhoto: _capturePhoto,
              pickFromGallery: _pickFromGallery,
              flipCamera: _flipCamera,
              onCheckPressed: _analyzeEmotion,
              onCheckLoading: _isProcessingImage,
              isProcessing: _isProcessingImage,
            ),
          ),
        ],
      ),
    );
  }
}
