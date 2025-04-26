import 'dart:io';

import 'package:camera/camera.dart';
import 'package:emotioneye/Screens/result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/camera_service.dart';
import '../services/image_processor_service.dart';
import '../widgets/photo_clicked_widget.dart';
import '../widgets/camera_help_dialog.dart';

class MainCamera extends StatefulWidget {
  const MainCamera({super.key, this.photoClicked = false});
  final bool photoClicked;

  @override
  State<MainCamera> createState() => _MainCameraState();
}


class _MainCameraState extends State<MainCamera> with WidgetsBindingObserver {
  bool textFieldVisibility = false;
  final TextEditingController _controller  = TextEditingController();
  final CameraService _cameraService = CameraService();

  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  FlashMode _flashMode = FlashMode.auto;

  XFile? _capturedImage;
  bool _isProcessingImage = false;
  bool photoClicked = false;
  bool _isCameraInitialized = false;

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
    photoClicked = false;
    _isCameraInitialized = false;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("App lifecycle state changed to: $state");
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

    setState(() {
      _isProcessingImage = true;
      textFieldVisibility = true;
    });

    try {
      final image = await _cameraService.capturePhoto();
      final processed = (_selectedCameraIndex == 1)
          ? await flipImageHorizontally(image)
          : image;

      setState(() {
        _capturedImage = processed;
        photoClicked = true;
      });
    } catch (e) {
      _showSnackBar("Capture error: $e", isError: true);
    } finally {
      setState(() => _isProcessingImage = false);
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() => _isProcessingImage = true);

    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _capturedImage = pickedFile;
          photoClicked = true;
          textFieldVisibility = true;
        });
      }
    } catch (e) {
      _showSnackBar("Gallery error: $e", isError: true);
    } finally {
      setState(() => _isProcessingImage = false);
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras == null || _cameras!.length <= 1) return;

    setState(() => _isCameraInitialized = false);

    try {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
      await _cameraService.initializeCamera(_cameras!, _selectedCameraIndex);
      await _cameraService.setFlashMode(_flashMode);
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      _showSnackBar("Camera switch error: $e", isError: true);
      // Try to recover by initializing the previous camera
      _selectedCameraIndex = (_selectedCameraIndex - 1 + _cameras!.length) % _cameras!.length;
      await _cameraService.initializeCamera(_cameras!, _selectedCameraIndex);
      setState(() => _isCameraInitialized = true);
    }
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
    if (_controller.text.isEmpty){
      _showSnackBar("Please enter Server IP Address!", isError: true);
      return;
    }
    if (_capturedImage == null) return;

    setState(() => _isProcessingImage = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("url", _controller.text);

      // Navigate to result page - analysis will happen there
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            imageFile: XFile(_capturedImage!.path),
          ),
        ),
      );
    } catch (e) {
      _showSnackBar("Error: $e", isError: true);
    } finally {
      setState(() => _isProcessingImage = false);
    }
  }

  void _togglePhotoClicked() {
    setState(() {
      photoClicked = !photoClicked;
      _capturedImage = null;
      textFieldVisibility = false;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: isError ? Colors.red.shade800 : Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
          duration: Duration(seconds: 4),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red, // text/icon color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Text("Ok"),
              ),
            ],
          ),
        )
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

  // Method to save URL to history
  Future<void> _saveUrl(String url) async {
    if (url.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();

    // Save as current URL
    await prefs.setString('url', url);

    // Save to URL history
    List<String> urlHistory = prefs.getStringList('url_history') ?? [];

    // Remove if already exists (to avoid duplicates)
    urlHistory.remove(url);

    // Add to front of list
    urlHistory.insert(0, url);

    // Limit history to 10 items
    if (urlHistory.length > 10) {
      urlHistory = urlHistory.sublist(0, 10);
    }

    await prefs.setStringList('url_history', urlHistory);
  }

  // Method to show URL history dialog
  void _showUrlHistoryDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> urlHistory = prefs.getStringList('url_history') ?? [];

    if (urlHistory.isEmpty) {
      _showSnackBar("No History Found", isError: true);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('URL History'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: urlHistory.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  urlHistory[index],
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                leading: Icon(Icons.link),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                dense: true,
                onTap: () {
                  _controller.text = urlHistory[index];
                  Navigator.of(context).pop();
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete_outline, size: 20),
                  onPressed: () async {
                    urlHistory.removeAt(index);
                    await prefs.setStringList('url_history', urlHistory);
                    Navigator.of(context).pop();
                    _showUrlHistoryDialog(context);
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await prefs.remove('url_history');
              Navigator.of(context).pop();
              _showSnackBar("URL History Cleared");
            },
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(225, 0, 31, 84),
        iconTheme: IconThemeData(
          color: Colors.white, // changes the back button color
        ),
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
                child: photoClicked && _capturedImage != null
                    ? _buildCapturedPreview()
                    : _buildCameraPreview(),

              ),
              Visibility(
                visible: textFieldVisibility && !_isProcessingImage,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'e.g: 192.168.1.1',
                      labelText: 'Enter Server IP Address',
                      border: OutlineInputBorder(),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.history),
                            tooltip: 'Show URL history',
                            onPressed: () {
                              _showUrlHistoryDialog(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.save),
                            tooltip: 'Save URL',
                            onPressed: () async {
                              final url = _controller.text.trim();
                              if(url.isEmpty){
                                _showSnackBar("IP Field is empty!", isError: true);
                              }else {
                                await _saveUrl(url);
                                _showSnackBar("URL Saved");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9\.]*$'))],
                  ),
                ),
              ),
              SizedBox(
                height: 80,
                child: PhotoClickedWidget(
                  photoClicked: photoClicked,
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
        ],
      ),
    );
  }
}