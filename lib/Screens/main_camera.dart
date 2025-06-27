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
    debugPrint("[MainCamera] initState() called. photoClicked: ${widget.photoClicked}");

    if (!widget.photoClicked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint("[MainCamera] Calling _initializeCamera() from post-frame");
        _initializeCamera();
      });
    } else {
      setState(() {
        photoClicked = true;
      });
    }
  }


  @override
  void dispose() async{
    debugPrint("----------------------In dispose function");
    WidgetsBinding.instance.removeObserver(this);
    // Make sure camera is released properly
    _disposeCamera();
    await Future.delayed(Duration(milliseconds: 500));
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    debugPrint("----------------------in didChangeAppLifecycleState function");
    // Handle app lifecycle changes
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      // Release camera when app is inactive or paused
      _disposeCamera();
      await Future.delayed(Duration(milliseconds: 500));
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize camera when app is resumed, but only if we're in camera mode
      if (!photoClicked && !_isCameraInitialized) {
        _initializeCamera();
      }
    }
  }

  // Method to dispose camera resources
  Future<void> _initializeCamera() async {
    debugPrint("[MainCamera] _initializeCamera() START. Already initialized: $_isCameraInitialized");

    // Don't reinitialize if already initialized
    if (_isCameraInitialized) return;

    try {
      _cameras = await availableCameras();
      debugPrint("[MainCamera] availableCameras(): Found ${_cameras?.length}");

      if (_cameras != null && _cameras!.isNotEmpty) {
        await _cameraService.initializeCamera(_cameras!, _selectedCameraIndex);
        await _cameraService.setFlashMode(_flashMode);
        setState(() {
          _isCameraInitialized = true;
        });
        debugPrint("[MainCamera] _isCameraInitialized set to true.");
      } else {
        _showSnackBar("No cameras available", isError: true);
      }
    } catch (e, s) {
      debugPrint("[MainCamera] ERROR during _initializeCamera(): $e\nStackTrace:\n$s");
      _showSnackBar("Camera initialization error: $e", isError: true);
    }

    debugPrint("[MainCamera] _initializeCamera() END. _isCameraInitialized: $_isCameraInitialized");
  }

  Future<void> _disposeCamera() async {
    debugPrint("[MainCamera] _disposeCamera() called. Initialized? $_isCameraInitialized");
    if (_isCameraInitialized) {
      _cameraService.dispose();
      setState(() {
        _isCameraInitialized = false;
      });
      debugPrint("[MainCamera] Camera disposed and _isCameraInitialized set to false.");
    }
  }

  Future<void> _capturePhoto() async {
    debugPrint("[MainCamera] _capturePhoto() called. Initialized? $_isCameraInitialized");

    if (!_isCameraInitialized) {
      await _initializeCamera();
      if (!_isCameraInitialized) {
        debugPrint("[MainCamera] Camera still not initialized after retry.");
        return;
      }
    }

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

      debugPrint("[MainCamera] Photo captured and stored at: ${processed.path}");

      _disposeCamera();  // Safe to dispose here
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      debugPrint("[MainCamera] Photo capture ERROR: $e");
      _showSnackBar("Capture error: $e", isError: true);
    } finally {
      setState(() => _isProcessingImage = false);
    }
  }


  Future<void> _pickFromGallery() async {
    debugPrint("----------------------PicFromgallery");

    // Dispose camera if it's initialized
    _disposeCamera();
    // You can keep or remove the delay as needed

    setState(() => _isProcessingImage = true);

    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _capturedImage = pickedFile;
          photoClicked = true;
          textFieldVisibility = true;
        });
      } else {
        debugPrint("[Gallery] No image was selected.");
        // Optional: reset states if needed
        setState(() {
          photoClicked = false;
          _capturedImage = null;
          textFieldVisibility = false;
        });
        _showSnackBar("No image selected.", isError: false);  // optional
      }

    } catch (e) {
      _showSnackBar("Gallery error: $e", isError: true);
    } finally {
      setState(() => _isProcessingImage = false);
    }
  }

  Future<void> _flipCamera() async {
    debugPrint("----------------------flip Camera");
    if (_cameras == null || _cameras!.length <= 1) return;

    // First dispose the current camera
    _disposeCamera();
    await Future.delayed(Duration(milliseconds: 500));

    try {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
      await _initializeCamera();
    } catch (e) {
      _showSnackBar("Camera switch error: $e", isError: true);
      // Try to recover by initializing the previous camera
      _selectedCameraIndex = (_selectedCameraIndex - 1 + _cameras!.length) % _cameras!.length;
      await _initializeCamera();
    }
  }

  Future<void> _toggleFlash() async {

    debugPrint("----------------------toggle fash");
    if (!_isCameraInitialized) return;

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
    debugPrint("----------------------get flash icon");
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
    debugPrint("----------------------analyzeEmotion");
    if (_controller.text.isEmpty){
      _showSnackBar("Please enter Server IP Address!", isError: true);
      return;
    }
    if (_capturedImage == null) return;

    try {
      print("--------------------- In try block of analyze emotion method");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("ip", _controller.text);

      print("--------------------- IP in main_camera.dart: ${_controller.text}");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            imageFile: XFile(_capturedImage!.path),
          ),
        ),
      ).then((_) {
        // This code runs when returning from the ResultPage
        setState(() {
          // Reset camera view state
          photoClicked = false;
          _capturedImage = null;
          textFieldVisibility = false;
        });
      });
    } catch (e) {
      _showSnackBar("Error: $e", isError: true);
    } finally {
      setState(() => _isProcessingImage = false);
    }
  }

  void _togglePhotoClicked() async {

    debugPrint("----------------------togglePhotoClicked");
    setState(() {
      photoClicked = !photoClicked;
      _capturedImage = null;
      textFieldVisibility = false;
    });

    // Initialize or dispose camera based on the new state
    if (!photoClicked) {
      _initializeCamera();
    } else {
      _disposeCamera();
      await Future.delayed(Duration(milliseconds: 500));
    }
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
    debugPrint("[MainCamera] _buildCameraPreview() called. Initialized: $_isCameraInitialized, PhotoClicked: $photoClicked");

    // Show loading indicator if camera isn't initialized yet
    if (!_isCameraInitialized && !photoClicked) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Initializing camera..."),
          ],
        ),
      );
    }

    if (!_isCameraInitialized) {
      return const Center(child: Text("Camera not available"));
    }

    final size = MediaQuery.of(context).size;
    final scale = 1 / (_cameraService.cameraController.value.aspectRatio * (size.width / size.height));

    return Transform.scale(
      scale: scale,
      child: CameraPreview(_cameraService.cameraController),
      // child: _selectedCameraIndex == 1
      //     ? Transform(
      //   alignment: Alignment.center,
      //   transform: Matrix4.rotationY(math.pi),
      //   child: CameraPreview(_cameraService.cameraController),
      // )
      //     : CameraPreview(_cameraService.cameraController),
    );
  }

  Widget _buildCapturedPreview() {
    debugPrint("----------------------buildCapturePreview");
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

  // Method to save ip to history
  Future<void> _saveip(String ip) async {
    if (ip.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();

    // Save as current ip
    await prefs.setString('ip', ip);

    // Save to ip history
    List<String> ipHistory = prefs.getStringList('ip_history') ?? [];

    // Remove if already exists (to avoid duplicates)
    ipHistory.remove(ip);

    // Add to front of list
    ipHistory.insert(0, ip);

    // Limit history to 10 items
    if (ipHistory.length > 10) {
      ipHistory = ipHistory.sublist(0, 10);
    }

    await prefs.setStringList('ip_history', ipHistory);
  }

  // Method to show ip history dialog
  void _showipHistoryDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> ipHistory = prefs.getStringList('ip_history') ?? [];

    if (ipHistory.isEmpty) {
      _showSnackBar("No IP history available!", isError: true);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select IP Address'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: ipHistory.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(ipHistory[index]),
                onTap: () {
                  setState(() {
                    _controller.text = ipHistory[index];
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
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
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'e.g: 192.168.1.1',
                      labelText: 'Enter Server IP Address',
                      border: OutlineInputBorder(),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.history),
                            tooltip: 'Show ip history',
                            onPressed: () {
                              _showipHistoryDialog(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.save),
                            tooltip: 'Save ip',
                            onPressed: () async {
                              final ip = _controller.text.trim();
                              if(ip.isEmpty){
                                _showSnackBar("IP Field is empty!", isError: true);
                              }else {
                                await _saveip(ip);
                                _showSnackBar("ip Saved");
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