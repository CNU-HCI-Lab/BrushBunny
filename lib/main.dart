import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'start_page.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        '/start': (context) => const StartPage(),
        '/home': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), //로그인상태검사
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //로그인되어있으면 HomePage()
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
