import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';

class EmotionApiService {
  static Future<String> getEmotion(XFile image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.206.43:5000/predict'),
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
