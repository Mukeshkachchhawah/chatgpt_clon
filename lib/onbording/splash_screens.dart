import 'dart:async';

import 'package:chatgpt_clon/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  // ignore: no_logic_in_create_state
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Text(
        "ChatGpt",
        style: TextStyle(fontSize: 40, color: Colors.white),
      )),
    );
  }
}
