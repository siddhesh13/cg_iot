import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:package_info/package_info.dart';
import 'home_screen.dart';
import '../utils/navigation.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _version = '';
  static const Color textColor =  Color(0xFF2C2C2C);
  @override
  void initState() {
    super.initState();
    _getAppVersion();
    Timer(const Duration(seconds: 3), () {
      navigateTo(context, HomeScreen());
    });
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFB6DACF), ////ECFFE6
          /*gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.lightGreenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),*/
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset('assets/images/logo.png',
              width: 200.0,  // Set the width you want
  height: 200.0, // Set the height you want
  ),
              const SizedBox(height: 20),
               Text(
                'CG IoT App',
                style: GoogleFonts.poppins(fontSize: 24, color: textColor, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
               Text(
                'Welcome to Curiosity Gym IoT App',
                style: GoogleFonts.poppins(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 10),
              Text(
                'Version $_version',
                style: GoogleFonts.poppins(fontSize: 14, color:textColor),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
