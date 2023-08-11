// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool loading = false;

  int curYear = DateTime.now().year;

  List data = [];
  List data1 = [];
  List data2 = [];
  var userapi;
  var passapi;
  var appsVersion;
  var appsBuild;

  Future<void> getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String appVersion = packageInfo.version;
    final String appBuild = packageInfo.buildNumber;
    setState(() {
      appsVersion = appVersion;
      appsBuild = appBuild;
    });
  }

  Future<void> logout() async {
    setState(() {
      data.clear();
      data1.clear();
      data2.clear();
    });

    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

  @override
  void initState() {
    super.initState();
    curYear = DateTime.now().year;
    getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Image.asset(
              'assets/images/appsicon.png',
              scale: 5,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Lion Reserve",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor * 30,
                  letterSpacing: 10),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Version:",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor * 20),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "$appsVersion build $appsBuild",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor * 20),
            ),
            const SizedBox(
              height: 15,
            ),
            curYear == 2023
                ? Text(
                    "\u00A9 Copyright 2023",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor * 15),
                  )
                : Text(
                    "\u00A9 Copyright 2023 - $curYear",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor * 15),
                  ),
          ],
        ),
      ),
    );
  }
}
