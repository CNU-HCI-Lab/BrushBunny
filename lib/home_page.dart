import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Colors.yellow[50],
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: const Color.fromARGB(255, 234, 166, 117),
          title: Text(
            'BRUSH BUNNY ₍ᐢ.ˬ.ᐢ₎',
            style: TextStyle(fontFamily: 'HS-yuji', fontSize: 19.sp),
          ),
          //로그아웃
          actions: [
            IconButton(
              onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text('로그아웃'),
                        content: const Text('로그아웃 하시겠습니까?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'OK');
                              FirebaseAuth.instance.signOut();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      )),
              icon: const Icon(
                Icons.logout_rounded,
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                '메인홈페이지',
              ),
              Text(
                'Brush Bunny',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }
}
