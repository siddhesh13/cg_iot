// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';
import '../utils/navigation.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      navigateTo(context, HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.jpg'),
            SizedBox(height: 20),
            Text('CuriosityGym IoT', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
