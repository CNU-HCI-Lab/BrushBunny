import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class HomeMainFeed extends StatefulWidget {
  const HomeMainFeed({super.key});

  @override
  State<HomeMainFeed> createState() => _HomeMainFeedState();
}

class _HomeMainFeedState extends State<HomeMainFeed> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime now = DateTime.now();
  DateTime clearDayDate = DateTime.now();
  DateTime? _selectedDate;
  EventList<Event> listEvents = EventList<Event>(events: {});
  List<dynamic>? clearDay = [];
  bool? _isSmile;
  bool firstInit = false;
  bool selectMessage = true;
  int clearDayCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          } else {
            //clearDayDate[]값들을 시분초 0으로 만들어서 clearDayDate2[]에 저장
            List<DateTime> clearDayDate2 = [];
            for (int i = 0; i < clearDay!.length; i++) {
              DateTime tmp = clearDay![i].toDate();
              clearDayDate2
                  .add(DateTime(tmp.year, tmp.month, tmp.day, 0, 0, 0, 0));
            }
            //_selectedDate와 같은 값이 clearDayDate2에 있는지 확인
            if (clearDayDate2.contains(_selectedDate)) {
              _isSmile = true;
            } else {
              _isSmile = false;
            }

            //_selectedDate와 값은 값이 clearDayDate2에 몇개 있는지 확인
            int starCount = 0;
            for (int i = 0; i < clearDayDate2.length; i++) {
              if (clearDayDate2[i] == _selectedDate) {
                starCount++;
                selectMessage = false;
              }
            }

            return Stack(
              children: [
                Visibility(
                  //smile bunny
                  visible: _isSmile!,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 60.w,
                      color: Colors.yellow[50],
                      child: Image.asset('assets/images/Smile_Bunny.png'),
                    ),
                  ),
                ),
                Visibility(
                  //smile bunny
                  visible: !_isSmile!,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 60.w,
                      color: Colors.yellow[50],
                      child: Image.asset('assets/images/surpriseBunny.png'),
                    ),
                  ),
                ),
                calendarWidget(),
                Visibility(
                  visible: selectMessage,
                  child: Align(
                    alignment: Alignment.center + const Alignment(0, 0.2),
                    child: SizedBox(
                      height: 30.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 35.w,
                            color: const Color.fromARGB(255, 255, 226, 226),
                            child: Text(
                              '양치질 기록확인',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 19.sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            color: Colors.white,
                            child: Text(
                              '달력의 날짜를 선택해주세요.',
                              style: TextStyle(
                                  fontSize: 18.sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (clearDayDate2.contains(_selectedDate))
                  Align(
                    alignment: Alignment.center,
                    child: //clearDayCount 만큼 별 출력
                        Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        starCount,
                        (index) => const Icon(
                          Icons.star_rounded,
                          size: 35,
                          color: Color.fromARGB(255, 255, 200, 0),
                        ),
                      ),
                    ),
                  ),
                if (clearDayDate2.contains(_selectedDate))
                  Align(
                    alignment: Alignment.center + const Alignment(0, 0.1),
                    child: Container(
                      color: Colors.white,
                      child: Text(
                        '양치질 횟수 : $starCount',
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                  ),
              ],
            );
          }
        },
      );
    });
  }

  Widget calendarWidget() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            //달력
            CalendarCarousel<Event>(
              height: 50.h,
              width: 100.w,
              selectedDateTime: _selectedDate, //선택된 날짜
              onDayPressed: (DateTime date, List<Event> events) {
                setState(() {
                  _selectedDate = date;
                });
              },
              weekendTextStyle: const TextStyle(
                color: Colors.red,
              ),
              selectedDayTextStyle: const TextStyle(
                color: Colors.black,
              ),
              selectedDayButtonColor: Colors.lightBlue,
              todayButtonColor: Colors.lightGreen,
              todayTextStyle: const TextStyle(
                color: Colors.black54,
              ),
              thisMonthDayBorderColor: Colors.grey,
              weekFormat: false,
              markedDatesMap: listEvents, //listEvents에 표시된 날짜를 달력에 표시함.
              markedDateShowIcon: true,
              markedDateIconMaxShown: 1,
              markedDateIconBuilder: (event) {
                return const Icon(
                  Icons.star_rounded,
                  size: 35,
                  color: Color.fromARGB(255, 255, 200, 0),
                );
              },
              markedDateMoreShowTotal: null,
              showIconBehindDayText: true,
            ),
          ],
        ),
      ),
    );
  }

  Future _getData() async {
    User? user = auth.currentUser;
    String? uid = user!.uid;
    _isSmile = true;

    if (mounted) {
      await firestore
          .collection('user_reward_info')
          .doc(uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          //uid있음
          if (mounted) {
            await firestore
                .collection('user_reward_info')
                .doc(uid)
                .get()
                .then((DocumentSnapshot documentSnapshot) {
              if (documentSnapshot.exists) {
                clearDay = documentSnapshot['clear_day'];
                clearDayCount = clearDay!.length;
                for (int i = 0; i < clearDayCount; i++) {
                  clearDayDate = clearDay![i].toDate();
                  DateTime clearDayDate2 = DateTime(clearDayDate.year,
                      clearDayDate.month, clearDayDate.day, 0, 0, 0, 0, 0);
                  listEvents.add(
                    clearDayDate2,
                    Event(
                      date: clearDayDate2,
                      title: '양치질완료',
                      icon: const Icon(Icons.star),
                    ),
                  );
                }
                if (firstInit == false) {
                  setState(() {});
                  firstInit = true;
                }
                //print(clearDay);
              } else {
                //print('값이 존재하지 않습니다');
              }
            });
          } else {
            //print('값이 존재하지 않습니다');
          }
        }
      });
      return "Success!";
    }
  }
}
