import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:oral_hygiene_habits/brushing_clear.dart';
import 'package:just_audio/just_audio.dart';

import 'main.dart';

class BrushingCamera extends StatefulWidget {
  const BrushingCamera({
    Key? key,
    required this.onImage,
    this.initialDirection = CameraLensDirection.front,
    required this.goodLevel,
    required this.badLevel,
    required this.status,
    required this.goodCount2,
    required this.realbadLevel,
  }) : super(key: key);

  final Function(InputImage inputImage) onImage;
  final CameraLensDirection initialDirection;
  final int goodCount2;
  final int goodLevel;
  final int badLevel;
  final String status;
  final int realbadLevel;

  @override
  State<BrushingCamera> createState() => _BrushingCameraState();
}

class _BrushingCameraState extends State<BrushingCamera>
    with TickerProviderStateMixin {
  final CustomTimerController _timer = CustomTimerController();
  CameraController? _controller;
  int _cameraIndex = -1;
  String? clearTime;
  String timeProcessBar = "0";

  AudioPlayer audioPlay = AudioPlayer();
  Future audioPlayer() async {
    await audioPlay.setAsset('assets/audio/brushing_song.mp3');
    await audioPlay.setSpeed(1);
    await audioPlay.setVolume(30);
    await audioPlay.setLoopMode(LoopMode.one);
    await audioPlay.play();
  }

  @override
  void initState() {
    audioPlayer();
    if (cameras.any(
      (element) =>
          element.lensDirection == widget.initialDirection &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
            element.lensDirection == widget.initialDirection &&
            element.sensorOrientation == 90),
      );
    } else {
      for (var i = 0; i < cameras.length; i++) {
        if (cameras[i].lensDirection == widget.initialDirection) {
          _cameraIndex = i;
          break;
        }
      }
    }
    _timer.start();
    _startLiveFeed();
    super.initState();
  }

  @override
  void dispose() {
    audioPlay.dispose();
    _stopLiveFeed();
    _timer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 166, 117),
      ),
      body: _liveFeedBody(),
    );
  }

  Widget _liveFeedBody() {
    String status = widget.status;
    int goodLevel = widget.goodLevel;
    int badLevel = widget.badLevel;

    if (_controller?.value.isInitialized == false) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _controller!.value.aspectRatio;
    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Transform.scale(
            scale: scale,
            child: Center(
              child: CameraPreview(_controller!),
            ),
          ),
          if (status == 'good' && goodLevel <= 20)
            _goodBackground20(), //good일때 배경
          if (status == 'good' && goodLevel > 20 && goodLevel <= 50)
            _goodBackground50(),
          if (status == 'good' && goodLevel > 50) _goodBackground100(),
          //if (status == 'bad' && badLevel > 2) _badBackground(),
          Align(
            //양치질 시간표시
            alignment: Alignment.topCenter + const Alignment(0, 0.05),
            child: _timerWidget(),
          ),
          Align(
            //시간 process표시
            alignment: Alignment.topCenter + const Alignment(0, 0.2),
            child: _timeBar(),
          ),
          Align(
            //goodLevel표시
            alignment: Alignment.topCenter + const Alignment(0, 0.35),
            child: _processGood(),
          ),
          Align(
            //양치질끝내기
            alignment: Alignment.bottomCenter + const Alignment(0, -0.2),
            child: ElevatedButton(
                onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('양치질 끝내기'),
                          content: const Text('양치질을 종료하시겠습니까?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('아니요'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context, 'OK');
                                //현재 창 종료하고 /brushing_claer 로 이동
                                _timer.pause();
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BrushingClear(
                                      time: clearTime,
                                      goodCount: widget.goodLevel,
                                      badCount: widget.realbadLevel,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('네'),
                            ),
                          ],
                        )),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xffBB5B3E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text('양치질 끝내기',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ),
        ],
      ),
    );
  }

  Widget _timerWidget() {
    return CustomTimer(
        controller: _timer,
        //upcount
        begin: const Duration(),
        end: const Duration(minutes: 5),
        builder: (time) {
          timeProcessBar = time.duration.inSeconds.toString();
          clearTime = "${time.minutes}:${time.seconds}";
          return Text("${time.minutes}:${time.seconds}",
              style: const TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Color.fromARGB(255, 71, 71, 71),
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                  fontSize: 40.0,
                  fontFamily: 'HS-yuji'));
        });
  }

  Widget _badBackground() {
    //bad일때 배경
    return Opacity(
        opacity: 0.7,
        child: WeatherBg(
          weatherType: WeatherType.thunder,
          //화면너비
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ));
  }

  Widget _goodBackground20() {
    //goodLevel이 20이하일때 배경
    return AnimatedBackground(
      behaviour: RandomParticleBehaviour(
        options: const ParticleOptions(
          baseColor: Colors.white,
          spawnOpacity: 0.0,
          opacityChangeRate: 0.25,
          minOpacity: 0.3,
          maxOpacity: 0.5,
          spawnMinSpeed: 50.0,
          spawnMaxSpeed: 100.0,
          spawnMinRadius: 7.0,
          spawnMaxRadius: 15.0,
          particleCount: 40,
        ),
        paint: Paint()..style = PaintingStyle.fill,
      ),
      vsync: this,
      child: const SizedBox(),
    );
  }

  Widget _goodBackground50() {
    //goodLevel이 50이하일때 배경
    return AnimatedBackground(
      behaviour: BubblesBehaviour(
        options: const BubbleOptions(
          bubbleCount: 20,
          minTargetRadius: 10,
          maxTargetRadius: 30,
          growthRate: 18,
        ),
      ),
      vsync: this,
      child: const SizedBox(),
    );
  }

  Widget _goodBackground100() {
    //goodLevel이 50이상일때 배경, 하트이미지
    return AnimatedBackground(
      behaviour: RandomParticleBehaviour(
        options: const ParticleOptions(
          spawnOpacity: 0.0,
          opacityChangeRate: 0.25,
          minOpacity: 0.5,
          maxOpacity: 1,
          spawnMinSpeed: 50.0,
          spawnMaxSpeed: 100.0,
          spawnMinRadius: 7.0,
          spawnMaxRadius: 15.0,
          particleCount: 35,
          image: Image(
            image: AssetImage('assets/images/heart.png'),
          ),
        ),
      ),
      vsync: this,
      child: const SizedBox(),
    );
  }

  Widget _processGood() {
    //goodLevel진행을 나타내는 ProgressIndicator, 짧은버전. 10초
    int goodCount2 = widget.goodCount2;
    return Container(
        padding: const EdgeInsets.only(left: 35, right: 35),
        child: CircularProgressIndicator(
          strokeWidth: 10,
          value: goodCount2 / 10,
          backgroundColor: Colors.white54,
          valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 255, 136, 0)),
        ));
  }

  Widget _timeBar() {
    double processTimeCount = double.parse(timeProcessBar);
    return Container(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: LinearProgressIndicator(
          minHeight: 15,
          value: processTimeCount / 120,
          backgroundColor: Colors.white54,
          valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 0, 225, 255)),
        ));
  }

  //------------------------------------------------------------------------
  Future _startLiveFeed() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _processCameraImage(CameraImage image) async {
    //MLKit을 이용하여 카메라이미지로 버퍼만드는 함수
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[_cameraIndex];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    widget.onImage(inputImage);
  }
  //------------------------------------------------------------------------
}
