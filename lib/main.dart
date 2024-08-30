import 'package:cg_iot/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CG IoT App',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.blueAccent,
        hintColor: Colors.greenAccent,

        // Define the default font family.
        fontFamily: 'Roboto',

        // Define the default text theme.
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),

        // Define the default AppBar theme.
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          elevation: 2.0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            //fontWeight: FontWeight.bold,
          ),
        ),

        // Define the default background color for Flashlight and Brightness screens.
        scaffoldBackgroundColor: Colors.white,

        // Define the SwitchTheme with different colors for active and inactive states.
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.blueAccent; // Active state
              }
              return Colors.grey; // Inactive state
            },
          ),
          trackColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.blue[200]; // Active state
              }
              return Colors.grey[400]; // Inactive state
            },
          ),
        ),

        // Define the default InputDecoration theme for TextFields.
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          labelStyle: TextStyle(color: Colors.blueAccent),
        ),

        // Define the default ButtonTheme for ToggleButtons or similar widgets.
        //toggleableActiveColor: Colors.blueAccent,

        // Define a gradient for specific screens like Flashlight and Brightness.
        canvasColor: Colors.lightBlueAccent.shade100,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.greenAccent,
          primary: Colors.blueAccent,
        ),
      ),
      home: SplashScreen(),
    );
  }
}
