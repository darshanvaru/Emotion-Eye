import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

Future<XFile> flipImageHorizontally(XFile image) async {
  final bytes = await image.readAsBytes();
  final img = await decodeImageFromList(bytes);
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

    final matrix = Matrix4.translationValues(img.width.toDouble(), 0.0, 0.0)
      ..multiply(Matrix4.diagonal3Values(-1.0, 1.0, 1.0));
    canvas.transform(matrix.storage);
  canvas.transform(matrix.storage);
  canvas.drawImage(img, Offset.zero, Paint());

  final flippedImage = await recorder.endRecording().toImage(img.width, img.height);
  final pngBytes = await flippedImage.toByteData(format: ui.ImageByteFormat.png);

  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final filename = 'CAP$timestamp.png';

  final tempDir = await Directory.systemTemp.createTemp();
  final tempFile = File('${tempDir.path}/$filename');
  await tempFile.writeAsBytes(pngBytes!.buffer.asUint8List());

  return XFile(tempFile.path);
}