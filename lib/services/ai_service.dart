import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class AIService {
  Interpreter? _interpreter;
  List<String> _labels = [];

  /// 🔥 LOAD MODEL
  Future<void> loadModel() async {
    try {
      print("🔄 Loading model...");

      _interpreter = await Interpreter.fromAsset(
        'assets/model/model.tflite',
      );

      /// LOAD LABELS (ALL KEPT)
      final labelsData =
          await rootBundle.loadString('assets/model/labels.txt');

      _labels = labelsData
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .toList();

      print("✅ Model Loaded Successfully");
      print("Labels loaded: ${_labels.length}");

    } catch (e) {
      print("❌ MODEL LOAD ERROR: $e");
    }
  }

  /// 🔥 PREDICT
  Future<String> predict(File imageFile) async {
    if (_interpreter == null) {
      throw Exception("Model not loaded");
    }

    print("📸 Processing image...");

    /// READ IMAGE
    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

    if (image == null) {
      throw Exception("Invalid image");
    }

    /// RESIZE IMAGE
    image = img.copyResize(image, width: 224, height: 224);

    /// CREATE INPUT TENSOR
    var input = Float32List(1 * 224 * 224 * 3);
    int index = 0;

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = image.getPixel(x, y);

        input[index++] = pixel.r / 255.0;
        input[index++] = pixel.g / 255.0;
        input[index++] = pixel.b / 255.0;
      }
    }

    var inputTensor = input.reshape([1, 224, 224, 3]);

    /// 🔥 AUTO-GET OUTPUT SHAPE (FIXED)
    final outputShape = _interpreter!.getOutputTensor(0).shape;
    final outputSize = outputShape[1];

    print("Model output size: $outputSize");

    /// CREATE OUTPUT BUFFER BASED ON MODEL
    var output = List.generate(
      1,
      (_) => List.filled(outputSize, 0.0),
    );

    print("🤖 Running inference...");

    _interpreter!.run(inputTensor, output);

    /// FIND BEST RESULT
    int maxIndex = 0;
    double maxValue = output[0][0];

    for (int i = 1; i < output[0].length; i++) {
      if (output[0][i] > maxValue) {
        maxValue = output[0][i];
        maxIndex = i;
      }
    }

    /// 🔥 SAFE LABEL ACCESS (IMPORTANT)
    String result;

    if (maxIndex < _labels.length) {
      result = _labels[maxIndex];
    } else {
      result = "Unknown Breed";
    }

    print("✅ Prediction Done: $result");

    return result;
  }
}