import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sih/consts/firebase_consts.dart';
import 'package:sih/screen/home/home_screen.dart';
import 'package:sih/screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 5), () async {
      if (await auth.currentUser != null) {
        // Navigator.push(
        // context, MaterialPageRoute(builder: (c) => HomeScreen()));
        Get.offAll(() => HomeScreen());
      } else {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (c) => LoginScreen()));
        // Get.offAll(() => LoginScreen());
        Get.off(() => LoginScreen());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Hello, Welcome in SIH"),
          SizedBox(
            height: 15,
          ),
          CircularProgressIndicator(),
        ],
      ),
    ));
  }
}
