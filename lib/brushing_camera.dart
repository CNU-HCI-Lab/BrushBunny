import 'dart:async';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
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
            //카메라 화면 비율을 위한 변수
            final size = MediaQuery.of(context).size;
            var scale = size.aspectRatio * _controller!.value.aspectRatio;
            if (scale < 1) scale = 1 / scale;

            return Scaffold(
              backgroundColor: Colors.yellow[50],
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 234, 166, 117),
              ),
              body:
                  ResponsiveSizer(builder: (context, orientation, deviceType) {
                return Stack(
                  children: [
                    Center(
                      child: Transform.scale(
                        scale: scale,
                        child: Center(
                          child: CameraPreview(_controller!),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            );
          } else {
            //카메라 로딩중 표시화면
            return const Center(child: CircularProgressIndicator());
          }
        }),
        future: _initializeControllerFuture);
  }
}
