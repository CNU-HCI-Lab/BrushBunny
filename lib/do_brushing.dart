import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DoBrushing extends StatefulWidget {
  const DoBrushing({super.key});

  @override
  State<DoBrushing> createState() => _DoBrushingState();
}

class _DoBrushingState extends State<DoBrushing> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('사용방법 및 주의사항',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 1.h),
                const Text('- 치약과 칫솔을 미리 준비해주세요.'),
                const Text('- 스마트폰을 적절한 위치에 두고 양치질을 시작하세요.'),
                const Text('- 카메라와 너무 멀면 인식이 되지 않습니다.'),
                const Text('- 양치질이 끝나면 \'양치질 끝내기\' 버튼을 눌러주세요.'),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          const Text('양치질 할 준비가 되었나요?', style: TextStyle(fontSize: 20)),
          const Text('준비가 되었으면, 아래 버튼을 눌러주세요!'),
          SizedBox(height: 1.h),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xffFFC6A2))),
              onPressed: () {
                Navigator.pushNamed(context, '/brushing_label');
              },
              child: const Text('혼자서 양치질 하기')),
          SizedBox(height: 3.h),
          Container(
            padding: const EdgeInsets.all(5),
            //둥근모서리
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 255, 248, 242),
            ),
            width: 88.w,
            child: Image.asset('assets/images/how_brushing.png'),
          )
        ],
      );
    });
  }
}
