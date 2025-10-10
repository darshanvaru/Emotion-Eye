import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class EmotionApiService {
  static Future<String> getEmotion(XFile image) async {

    // final prefs = await SharedPreferences.getInstance();
    final ip = "https://darshanvaru-emotion-eye-detector.hf.space/predict";

    debugPrint("_______________Pref Link in emotion_api_service.dart: $ip");
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ip),
    );
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();
    final resBody = await response.stream.bytesToString();
    debugPrint("_______________ Status: ${response.statusCode}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(resBody);
      final emotion = decoded['emotion'] ?? 'unknown';
      debugPrint("_______________ Label: $emotion");

      return emotion;
    } else {
      throw Exception('API Error ${response.statusCode}');
    }
  }
}