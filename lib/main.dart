// lib/main.dart
import 'package:cg_iot/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CG IoT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),//SplashScreen(),
    );
  }
}
//keep credentials
//theme
//app size