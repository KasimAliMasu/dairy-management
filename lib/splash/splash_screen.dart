import 'dart:async';
import 'package:dairy_management/login/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 10), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            color: Colors.blue,
            width: double.infinity,
            height: double.infinity,
            child: Text('Milk'),
          ),
          Positioned(
              top: 0,
              child: Image.asset(
                'assets/image/milk-removebg-preview.png',
                height: 150,
              ),),
          Positioned(
            bottom: 0,
            child: Image.asset(
              'assets/image/milk_flipped.png',
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}
