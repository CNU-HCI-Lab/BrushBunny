import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RewardMovie extends StatefulWidget {
  const RewardMovie({super.key, required this.clearMovieId});

  final String clearMovieId;

  @override
  State<RewardMovie> createState() => _RewardMovieState();
}

class _RewardMovieState extends State<RewardMovie> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  YoutubePlayerController? youtbController;

  @override
  void initState() {
    youtbController = YoutubePlayerController(
      initialVideoId: widget.clearMovieId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget youtubePlayerBuild() {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: youtbController!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: const ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
        onReady: () {
          print('Player is ready.');
        },
      ),
      builder: (context, player) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('영상보상을 획득했어요!',
                style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 105, 105, 105))),
            SizedBox(height: 2.h),
            player,
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {
                    youtbController!.play();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.pause),
                  onPressed: () {
                    youtbController!.pause();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () {
                    youtbController!.pause();
                  },
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              '시즌 $seasonNum: 제 $episodeNum 화',
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              '[$movieName]',
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              '$movieTitle',
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 2.h),
            const Text('홈화면의 보상 탭에서도 영상을 확인할 수 있습니다.'),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xffF78F6E)),
              ),
              onPressed: () {
                //HOME으로 이동
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home', (Route<dynamic> route) => false);
              },
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: //가로모드일 때 숨기기
          MediaQuery.of(context).orientation == Orientation.portrait
              ? AppBar(
                  backgroundColor: const Color.fromARGB(255, 234, 166, 117),
                )
              : null,
      body: FutureBuilder(
        future: getFirebase(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text('error');
          } else {
            return youtubePlayerBuild();
          }
        },
      ),
    );
  }

  String? youtubeId;
  String? seasonNum;
  String? episodeNum;
  String? movieName;
  String? movieTitle;

  Future getFirebase() async {
    User? user = auth.currentUser;
    String? uid = user?.uid;
    int? index;
    await db
        .collection('user_reward_info')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        if ((documentSnapshot.data() as Map<String, dynamic>)
            .containsKey('movie_index')) {
          index = documentSnapshot['movie_index'];

          //유튜브아이디얻기
          await db
              .collection('reward_movies')
              .doc(index.toString())
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              if ((documentSnapshot.data() as Map<String, dynamic>)
                  .containsKey('id')) {
                youtubeId = documentSnapshot['id'];
                seasonNum = documentSnapshot['season'];
                episodeNum = documentSnapshot['episode'];
                movieName = documentSnapshot['name'];
                movieTitle = documentSnapshot['title'];
                //print('id: $youtubeId');
              } else {
                //print('존재하지 않는 영상');
              }
            } else {}
          });
        } else {
          //print('사용자가 얻은 영상이 없습니다. (movie_index fied없음)');
        }
      } else {
        //print('사용자가 얻은 영상이 없습니다.');
      }
    });
    return "";
  }
}
