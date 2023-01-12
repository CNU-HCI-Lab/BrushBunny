import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';

class LearningOralHygiene extends StatefulWidget {
  const LearningOralHygiene({super.key});

  @override
  State<LearningOralHygiene> createState() => _LearningOralHygieneState();
}

class _LearningOralHygieneState extends State<LearningOralHygiene> {
  final CarouselController _controller = CarouselController();
  VideoPlayerController? _videoController;
  Future<void>? _initializeVideoPlayerFuture;
  int _current = 0;

  @override
  void initState() {
    // VideoPlayerController를 저장하기 위한 변수를 만듭니다. VideoPlayerController는
    // asset, 파일, 인터넷 등의 영상들을 제어하기 위해 다양한 생성자를 제공합니다.
    _videoController = VideoPlayerController.asset(
      'assets/movies/Howto_Brushing.mp4',
    );
    _initializeVideoPlayerFuture = _videoController?.initialize();

    super.initState();
  }

  @override
  void dispose() {
    // 자원을 반환하기 위해 VideoPlayerController를 dispose 시키세요.
    _videoController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetList = [
      howToBrushing(),
      brushingWithSong(),
      selectToothBrush(),
      dentalFloss(),
      diagnosisCavity(),
    ];

    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return Column(children: [
        Expanded(
          child: CarouselSlider(
            items: widgetList,
            carouselController: _controller,
            options: CarouselOptions(
                height: 80.h,
                autoPlay: false,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgetList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ]);
    });
  }

  Widget howToBrushing() {
    return Container(
        color: const Color.fromARGB(255, 216, 226, 221),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: 1.h),
          Container(
            //둥근모서리
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(10),
            child: Text('올바르게 양치질 하는 방법',
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 2.h),
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // 만약 VideoPlayerController 초기화가 끝나면, 제공된 데이터를 사용하여
                // VideoPlayer의 종횡비를 제한하세요.
                _videoController!.setVolume(2.0);
                return AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  // 영상을 보여주기 위해 VideoPlayer 위젯을 사용합니다.
                  child: VideoPlayer(
                    _videoController!,
                  ),
                );
              } else {
                // 만약 VideoPlayerController가 여전히 초기화 중이라면,
                // 로딩 스피너를 보여줍니다.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 158, 190, 172),
            onPressed: () {
              // 재생/일시 중지 기능을 `setState` 호출로 감쌉니다. 이렇게 함으로써 올바른 아이콘이
              // 보여집니다.
              setState(() {
                // 영상이 재생 중이라면, 일시 중지 시킵니다.
                if (_videoController!.value.isPlaying) {
                  _videoController!.pause();
                } else {
                  // 만약 영상이 일시 중지 상태였다면, 재생합니다.
                  _videoController!.play();
                }
              });
            },
            // 플레이어의 상태에 따라 올바른 아이콘을 보여줍니다.
            child: Icon(
              _videoController!.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
            ),
          )
        ]));
  }

  Widget brushingWithSong() {
    return Container(width: 100.w, color: Colors.blue, child: Text('동요'));
  }

  Widget selectToothBrush() {
    return Container(
        width: 100.w, color: Colors.green, child: Text('칫솔 고르는 TIP'));
  }

  Widget dentalFloss() {
    return Container(width: 100.w, color: Colors.yellow, child: Text('치실사용'));
  }

  Widget diagnosisCavity() {
    return Container(width: 100.w, color: Colors.orange, child: Text('충치진단방법'));
  }
}
