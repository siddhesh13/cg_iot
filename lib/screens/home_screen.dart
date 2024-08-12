// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'flashlight_screen.dart';
import 'microphone_screen.dart';
import 'brightness_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    FlashlightScreen(),
    MicrophoneScreen(),
    BrightnessScreen()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,  // Set selected item color
        backgroundColor: Colors.blueAccent, 
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.flashlight_on),
            label: 'Flashlight',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Microphone',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.brightness_6),
            label: 'Brightness',
          ),
        ],
      ),
    );
  }
}
