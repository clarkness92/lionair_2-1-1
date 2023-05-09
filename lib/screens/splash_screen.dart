// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 6),
        () => Navigator.pushReplacementNamed(context, 'login'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.red,
        child: Column(children: [
          const SizedBox(
            height: 200,
          ),
          Image.asset(
            'assets/images/logo.png',
            color: Colors.white,
          ),
          const SizedBox(
            height: 250,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: CircularPercentIndicator(
              animation: true,
              radius: 40.0,
              lineWidth: 5.0,
              percent: 1.0,
              animationDuration: 5700,
              center: const Text(
                "loading",
                style: TextStyle(
                    color: Colors.white, decoration: TextDecoration.none),
              ),
              progressColor: Colors.blue,
            ),
          ),
        ]));
  }
}
