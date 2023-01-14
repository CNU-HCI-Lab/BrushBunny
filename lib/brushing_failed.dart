import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BrushingFailed extends StatefulWidget {
  const BrushingFailed({
    super.key,
    this.time,
    this.goodCount,
    this.badCount,
    this.durationSeconds,
  });

  final String? time;
  final int? goodCount;
  final int? badCount;
  final int? durationSeconds;

  @override
  State<BrushingFailed> createState() => _BrushingFailedState();
}

class _BrushingFailedState extends State<BrushingFailed> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  int movieIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;
    String? uid = user?.uid;

    checkTodayBrushing() {
      //collection: user_reward_info
      //document : uid
      //document에 uid가 없으면 새로 생성
      //clear_day 필드 배열에 오늘 날짜 저장
      db.collection('user_reward_info').doc(uid).set({
        'clear_day': FieldValue.arrayUnion([DateTime.now()])
      }, SetOptions(merge: true));
      //print('양치완료');
    }

    recordTodayPoint() {
      //collection: user_reward_info
      //document : uid
      //document에 uid가 없으면 새로 생성
      //clear_day 필드 배열에 오늘 날짜 저장
      String dateGoodBadPoint =
          "${DateTime.now()}/${widget.time}/${widget.goodCount}/${widget.badCount}";
      db.collection('user_reward_info').doc(uid).set({
        'clear_point': FieldValue.arrayUnion([dateGoodBadPoint])
      }, SetOptions(merge: true));
      //print('양치완료');
    }

    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: const Color(0xfffffde7),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 234, 166, 117),
        ),
        body: Center(
            child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Image(
                image: const AssetImage('assets/images/surpriseBunny.png'),
                width: 60.w,
              ),
            ),
            Column(
              children: [
                SizedBox(height: 5.h),
                Text(
                  '양치질 완료!',
                  style:
                      TextStyle(fontSize: 23.sp, fontWeight: FontWeight.bold),
                ),
                const Text('좌우로 드래그하여 기록을 확인하세요!'),
                SizedBox(height: 2.h),
                claerCard(),
                SizedBox(height: 3.h),
                const Text(
                  '양치질 시간이 짧아서, 영상보상을 획득하지 못했어요.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1.h),
                const Text('다음에는 최소 2분 이상 양치질을 해주세요!'),
                SizedBox(height: 2.h),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xffFFC6A2),
                    ),
                  ),
                  onPressed: () async {
                    checkTodayBrushing();
                    recordTodayPoint();
                    if (!mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home', (Route<dynamic> route) => false);
                  },
                  child: const Text('홈으로 돌아가기',
                      style: TextStyle(
                        fontSize: 15,
                      )),
                ),
              ],
            ),
          ],
        )),
      );
    });
  }

  Widget claerCard() {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 2.0,
        reverse: false,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        enlargeStrategy: CenterPageEnlargeStrategy.zoom,
        enlargeFactor: 0.4,
      ),
      items: [
        Container(
          color: const Color(0xffA3CCC4),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '총 양치질 시간',
                  style: TextStyle(fontSize: 20),
                ),
                Text('${widget.time}', style: const TextStyle(fontSize: 30)),
              ],
            ),
          ),
        ),
        Container(
          color: const Color(0xffFFC6A2),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '칭찬포인트',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '${widget.goodCount}',
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: const Color(0xffAEAC9A),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '패널티',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '${widget.badCount}',
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
