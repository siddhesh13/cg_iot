// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flashlight_screen.dart';
//import 'microphone_screen.dart';
import 'brightness_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _children = [
    FlashlightScreen(),
    //MicrophoneScreen(),
    const BrightnessScreen()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navBarTheme = Theme.of(context).bottomNavigationBarTheme;
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: navBarTheme.selectedItemColor ?? Colors.white,  // Set selected item color
        unselectedItemColor: navBarTheme.unselectedItemColor ?? Colors.grey[300],
        backgroundColor: navBarTheme.backgroundColor ?? Color(0xFF2C2C2C),
        selectedLabelStyle: navBarTheme.selectedLabelStyle ?? GoogleFonts.poppins(),
        unselectedLabelStyle: navBarTheme.unselectedLabelStyle ?? GoogleFonts.roboto(), 
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.flashlight_on),
            label: 'Flashlight',
          ),
          /*
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Microphone',
          ),
          */
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Ambient Light',
          ),
        ],
      ),
    );
  }
}
