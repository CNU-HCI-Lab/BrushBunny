import 'dart:io' as io;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'brushing_camera.dart';

class BrushingLabel extends StatefulWidget {
  const BrushingLabel({super.key});

  @override
  State<BrushingLabel> createState() => _BrushingLabelState();
}

class _BrushingLabelState extends State<BrushingLabel> {
  late ImageLabeler _imageLabeler;
  bool _canProcess = false;
  bool _isBusy = false;
  String? _text;
  int _goodCount = 0;
  int _badCount = 0;
  int _goodLevel = 0;
  int _badLevel = 0;
  int _goodCount2 = 0;
  String _status = 'none';

  @override
  void initState() {
    super.initState();

    _initializeLabeler();
  }

  @override
  void dispose() {
    _canProcess = false;
    _imageLabeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrushingCamera(
      onImage: processImage,
      goodCount2: _goodCount2,
      goodLevel: _goodLevel,
      badLevel: _badLevel,
      status: _status,
    );
  }

  void _initializeLabeler() async {
    //google ML Kit imageLabel custom모델 사용
    const path = 'assets/ml/model_brushing.tflite';
    final modelPath = await _getModel(path);
    final options =
        LocalLabelerOptions(modelPath: modelPath, confidenceThreshold: 0.5);
    _imageLabeler = ImageLabeler(options: options);

    _canProcess = true;
  }

  void _incrementCounts(List labels) {
    //'good'일때 'bad'일때 카운트해서 5으로 나눈값을 goodLevel, badLevel에 저장
    //goodLevel과 badLevel을 brushing_camera.dart로 보내서 화면에 표시
    for (final label in labels) {
      if (label.label == 'good') {
        _goodCount += 1;
        _goodLevel = _goodCount ~/ 5;
        _goodCount2 += 1;
        if (_goodCount2 == 11) _goodCount2 = 0;
        _badCount = 0; //good일때 bad카운트 초기화
        _status = 'good';
        //print('good: $_goodLevel');
      } else if (label.label == 'bad') {
        _badCount += 1;
        _badLevel = _badCount ~/ 15;
        _status = 'bad';
        //print('bad: $_badLevel');
      }
    }
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final labels = await _imageLabeler.processImage(inputImage);

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
    } else {
      String text = 'Labels found: ${labels.length}\n\n';
      for (final label in labels) {
        text += 'Label: ${label.label}, '
            'Confidence: ${label.confidence.toStringAsFixed(2)}\n\n';
      }
      _text = text;
    }

    _incrementCounts(labels);

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<String> _getModel(String assetPath) async {
    if (io.Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await io.Directory(dirname(path)).create(recursive: true);
    final file = io.File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }
}
