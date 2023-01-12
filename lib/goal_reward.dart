import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class GoalReward extends StatefulWidget {
  const GoalReward({super.key});

  @override
  State<GoalReward> createState() => _GoalRewardState();
}

class _GoalRewardState extends State<GoalReward> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Uri _url = Uri.parse('https://flutter.dev');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return FutureBuilder(
          future: getFirebase(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            } else {
              //유튜브리스트 출력
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: youtubeId.length,
                itemBuilder: (context, index) {
                  _url = Uri.parse(
                      'https://www.youtube.com/watch?v=${youtubeId[index]}');
                  return Container(
                    margin: EdgeInsets.only(
                        left: 4.w, right: 4.w, top: 1.h, bottom: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 95, 95, 95),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _launchUrl,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: 3.w, right: 3.w, top: 1.h, bottom: 1.h),
                            child: Image.network(
                              "https://img.youtube.com/vi/${youtubeId[index]}/0.jpg",
                              width: 35.w,
                              height: 25.h,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 2.w, right: 2.w, top: 1.h, bottom: 1.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '[${movieName[index]}]',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Text(
                                  "시즌${seasonNum[index]}. ${episodeNum[index]}화",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 25.h,
                                  child: Text(
                                    movieTitle[index],
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          });
    });
  }

  List<String> youtubeId = [];
  List<String> seasonNum = [];
  List<String> episodeNum = [];
  List<String> movieName = [];
  List<String> movieTitle = [];

  Future getFirebase() async {
    User? user = auth.currentUser;
    String? uid = user?.uid;
    int? userMovieCount; //유저가 얻은 영상 수
    bool? trigger;

    await db
        .collection('user_reward_info')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userMovieCount = documentSnapshot['movie_index'];
        //print("userMovieCount: $userMovieCount");
      } else {
        userMovieCount = 0;
        //print('Document does not exist on the database');
      }
    });

    if (userMovieCount == 0) {
      return "소유하고 있는 보상이 없습니다.";
    } else {
      for (int i = 0; i < userMovieCount!; i++) {
        await db
            .collection('reward_movies')
            .doc((i + 1).toString())
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            youtubeId.add(documentSnapshot['id']);
            seasonNum.add(documentSnapshot['season']);
            episodeNum.add(documentSnapshot['episode']);
            movieName.add(documentSnapshot['name']);
            movieTitle.add(documentSnapshot['title']);
            trigger = true;
          } else {
            //print("존재하지 않는 영상");
            trigger = true;
          }
        });
      }
      //print(youtubeId);
      //print(seasonNum);
      return trigger;
    }
  }
}
