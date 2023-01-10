import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class BrushingCamera extends StatefulWidget {
  const BrushingCamera({super.key});

  @override
  State<BrushingCamera> createState() => _BrushingCameraState();
}

class _BrushingCameraState extends State<BrushingCamera> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  void readyCamera() async {
    final cameras = await availableCameras();
    List<CameraDescription> camera = cameras;
    _controller = CameraController(camera[1], ResolutionPreset.medium);
    _initializeControllerFuture = _controller!.initialize();
    setState(() {
      _initializeControllerFuture;
    });
  }

  @override
  void initState() {
    super.initState();
    readyCamera();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }),
        future: _initializeControllerFuture);
  }
}
