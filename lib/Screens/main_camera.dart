import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/camera_service.dart';
import '../services/emotion_api_service.dart';
import '../services/image_processor_service.dart';
import '../widgets/photo_clicked_widget.dart';
import '../widgets/camera_help_dialog.dart';

class MainCamera extends StatefulWidget {
  const MainCamera({super.key});

  @override
  State<MainCamera> createState() => _MainCameraState();
}

class _MainCameraState extends State<MainCamera> with WidgetsBindingObserver {
  final CameraService _cameraService = CameraService();

  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  FlashMode _flashMode = FlashMode.auto;

  XFile? _capturedImage;
  bool _photoClicked = false;
  bool _isCameraInitialized = false;
  bool _isProcessingImage = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Make sure camera is released properly
    _cameraService.dispose();
    // Reset state variables
    _capturedImage = null;
    _photoClicked = false;
    _isCameraInitialized = false;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if (state == AppLifecycleState.inactive) {
      // App is in background or switching between views
      _cameraService.dispose();
      setState(() => _isCameraInitialized = false);
    } else if (state == AppLifecycleState.resumed) {
      // App is in foreground
      if (_cameras != null && _cameras!.isNotEmpty) {
        _initializeCamera();
      }
    }
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      await _cameraService.initializeCamera(_cameras!, _selectedCameraIndex);
      await _cameraService.setFlashMode(_flashMode);
      setState(() => _isCameraInitialized = true);
    } else {
      _showSnackBar("No cameras available", isError: true);
    }
  }

  Future<void> _capturePhoto() async {
    if (!_isCameraInitialized) return;
    setState(() => _isProcessingImage = true);

    try {
      final image = await _cameraService.capturePhoto();
      final processed = (_selectedCameraIndex == 1)
          ? await flipImageHorizontally(image)
          : image;

      setState(() {
        _capturedImage = processed;
        _photoClicked = true;
      });
    } catch (e) {
      _showSnackBar("Capture error: $e", isError: true);
    } finally {
      setState(() => _isProcessingImage = false);
    }
  }

  Future<void> _pickFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _capturedImage = pickedFile;
        _photoClicked = true;
      });
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras == null || _cameras!.length <= 1) return;
    setState(() => _isCameraInitialized = false);
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    await _cameraService.initializeCamera(_cameras!, _selectedCameraIndex);
    await _cameraService.setFlashMode(_flashMode);
    setState(() => _isCameraInitialized = true);
  }

  Future<void> _toggleFlash() async {
    FlashMode newMode;
    switch (_flashMode) {
      case FlashMode.auto:
        newMode = FlashMode.torch;
        break;
      case FlashMode.torch:
        newMode = FlashMode.off;
        break;
      default:
        newMode = FlashMode.auto;
    }

    try {
      await _cameraService.setFlashMode(newMode);
      setState(() => _flashMode = newMode);
    } catch (e) {
      _showSnackBar("Flash error: $e", isError: true);
    }
  }

  IconData _getFlashIcon() {
    switch (_flashMode) {
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.torch:
        return Icons.flash_on;
      default:
        return Icons.flash_off;
    }
  }

  Future<void> _analyzeEmotion() async {
    if (_capturedImage == null) return;

    setState(() => _isProcessingImage = true);

    try {
      final emotion = await EmotionApiService.getEmotion(_capturedImage!);

      // Check if widget is still mounted before updating state
      if (mounted) {
        _showSnackBar("Emotion: $emotion");
        setState(() => _isProcessingImage = false);
      }
    } catch (e) {
      // Check if widget is still mounted before showing error
      if (mounted) {
        _showSnackBar("API error: $e", isError: true);
        setState(() => _isProcessingImage = false);
      }
    }
  }
  void _togglePhotoClicked() {
    setState(() {
      _photoClicked = !_photoClicked;
      _capturedImage = null;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isCameraInitialized || !_cameraService.cameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    final size = MediaQuery.of(context).size;
    final scale = 1 / (_cameraService.cameraController.value.aspectRatio * (size.width / size.height));
    return Transform.scale(
      scale: scale,
      child: CameraPreview(_cameraService.cameraController),
    );
  }

  Widget _buildCapturedPreview() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10.0, offset: Offset(0, 4))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(225, 0, 31, 84),
        actions: [
          if (_isCameraInitialized && _selectedCameraIndex == 0)
            IconButton(
              icon: Icon(_getFlashIcon(), color: Colors.white),
              onPressed: _isProcessingImage ? null : _toggleFlash,
            ),
          IconButton(
            icon: const Icon(Icons.help_outline_sharp, color: Colors.white),
            onPressed: _isProcessingImage
                ? null
                : () => showDialog(
              context: context,
              builder: (context) => const CameraHelpDialog(),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
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
                  isProcessing: _isProcessingImage,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}