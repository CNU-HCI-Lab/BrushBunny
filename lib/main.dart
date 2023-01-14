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
