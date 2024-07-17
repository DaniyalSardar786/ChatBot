import 'dart:async';

import 'package:chat_project/mock_bot.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  void initState() {
    super.initState();
    // Start a timer to navigate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      // Navigate to your desired screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MockBot()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
            "animations/animation1.json",
            height: 300,
            width: 400,
            // repeat: true,
            // reverse: true,
            fit: BoxFit.cover
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
