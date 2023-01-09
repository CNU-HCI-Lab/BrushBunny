import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xfffffde7),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 234, 166, 117),
        ),
        body: GestureDetector(
          //TextField를 벗어난 영역을 터치하면 키보드가 내려가도록 함
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: SizedBox(
              height: 65.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 8.h,
                    margin: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        fontSize: 21.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff484738),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: '이메일',
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        TextField(
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: '비밀번호',
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  ElevatedButton(
                    //회원가입버튼
                    onPressed: () async {
                      try {
                        //회원가입 성공시
                        await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                        if (!mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/main', (route) => false);
                      } catch (e) {
                        //print(e);
                      }
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        )),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffF78F6E)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(40.w, 5.h))),
                    child: Text(
                      '가입하기',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
