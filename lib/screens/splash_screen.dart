import 'package:flutter/material.dart';
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
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.lightGreenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset('assets/images/logo.jpg'),
              const SizedBox(height: 20),
              const Text(
                'CuriosityGym IoT',
                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Text(
                'Powered by CuriosityGym',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                'Version 1.0$_version',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
