import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';

class EmotionApiService {
  static Future<String> getEmotion(XFile image) async {
    const String ip ="https://darshanvaru-emotion-eye-detector.hf.space/predict";

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ip),
      );

      request.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decoded = jsonDecode(resBody);
        return (decoded['emotion'] ?? 'none').toString();
      } else {
        throw HttpException(
          'API Error: ${response.statusCode}',
        );
      }
    }

    // 🔴 DATA OFF / NO INTERNET
    on SocketException {
      throw SocketException('No internet connection');
    }

    // 🟡 SERVER NOT RESPONDING
    on TimeoutException {
      throw TimeoutException('Server not responding');
    }

    // 🔵 INVALID RESPONSE
    on FormatException {
      throw const FormatException('Invalid response from server');
    }
  }
}
