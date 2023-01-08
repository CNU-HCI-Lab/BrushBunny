import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        home: startPageWidget(),
      );
    });
  }

  Widget startPageWidget() {
    return Scaffold(
      backgroundColor: const Color(0xfffffde7),
      body: Stack(
        children: <Widget>[
          Pinned.fromPins(
            Pin(start: -73.0, end: -73.0),
            Pin(size: 537.0, end: -18.0),
            child:
                // Adobe XD layer: 'Rabbit' (group)
                Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(start: 0.0, end: 0.0),
                  Pin(size: 68.0, end: 18.0),
                  child:
                      // Adobe XD layer: 'Image_Background' (shape)
                      Container(
                    color: const Color(0xfff3ac7c),
                  ),
                ),
                // Adobe XD layer: 'circle_StartingImage' (shape)
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/circle_StartingImage.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  margin: const EdgeInsets.fromLTRB(20.0, 0.0, 19.0, 0.0),
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment(0.0, -(13.h) / (10.h + 10.h)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '내 아이를 위한 양치 습관 형성 앱',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xff707070),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: false,
                  ),
                  Text(
                    'Brushing Bunny',
                    style: TextStyle(
                      fontSize: 25.sp,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: false,
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  Text(
                    '로그인 후 사용 가능합니다.',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xff707070),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: false,
                  ),
                  SizedBox(
                    height: 2.5.h,
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: const Color(0xff707070),
                        letterSpacing: 1.5,
                      ),
                      children: const [
                        TextSpan(
                          text: '이메일',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: '을 이용하여 간편하게 회원가입하기',
                        ),
                      ],
                    ),
                    textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false),
                    textAlign: TextAlign.center,
                    softWrap: false,
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xffF78F6E)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          fixedSize:
                              MaterialStateProperty.all<Size>(Size(50.w, 5.h))),
                      child: const Text('이메일로 회원가입')),
                  ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xffFFC6A2)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          fixedSize:
                              MaterialStateProperty.all<Size>(Size(50.w, 5.h))),
                      child: const Text('로그인')),
                ],
              )),
        ],
      ),
    );
  }
}
