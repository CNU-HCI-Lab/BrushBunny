/*
 * Acknowledgemnet
 *
 * 이 기술은 과학기술정보통신부 및 정보통신기획평과원의
 * 융합보안 핵심인재 양성 사업의 연구 결과로 개발한 결과물입니다.
 *
 */

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:camera/camera.dart';
import 'firebase_options.dart';
import 'start_page.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'login_page.dart';
import 'do_brushing.dart';
import 'brushing_label.dart';
import 'brushing_failed.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brush Bunny',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      routes: {
        '/main': (context) => const MyApp(),
        '/start': (context) => const StartPage(),
        '/home': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/do_brushing': (context) => const DoBrushing(),
        '/brushing_label': (context) => const BrushingLabel(),
        '/brushing_failed': (context) => const BrushingFailed(),
        '/start_page': (context) => const StartPage(),
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), //로그인상태검사
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            //아니면 StartPage()
            return const StartPage();
          }
        },
      ),
    );
  }
}
