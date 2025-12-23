import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';

class EmotionApiService {
  static Future<String> getEmotion(XFile image) async {

    final ip = "https://darshanvaru-emotion-eye-detector.hf.space/predict";

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ip),
    );
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();
    final resBody = await response.stream.bytesToString();
    debugPrint("[EmotionApiService] Status of Request: ${response.statusCode}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(resBody);
      final emotion = decoded['emotion'] ?? 'unknown';
      debugPrint("[EmotionApiService] Received Label from Server: $emotion");

      return emotion;
    } else {
      throw Exception('API Error ${response.statusCode}');
    }
  }
}