import 'package:flutter/material.dart';
import 'theme.dart';  // Import your theme file
import 'package:cg_iot/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CG IoT App',
      theme: appTheme(),  // Use the theme from the separate file
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,  // Disable debug banner
    );
  }
}
