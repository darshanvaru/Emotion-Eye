import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmotionApiService {
  static Future<String> getEmotion(XFile image) async {

    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString("url")!.isEmpty ? 'http://192.168.174.43:5000/predict' : prefs.getString("url");
    print("__________________________________");
    print("URL: $url");
    print("__________________________________");
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(url!),
    );
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final decoded = jsonDecode(resBody);
      final emotion = decoded['emotion'] ?? 'unknown';

      return emotion;
    } else {
      throw Exception('API Error ${response.statusCode}');
    }
  }
}