import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme() {
  // Define your color palette
const Color primaryColor = Color(0xFF2C2C2C);  // Green
const Color secondaryColor = Color(0xFF4CAF50);  // Dark Grey
//const Color splashBackgroundColor = Color(0xFFB6DACF);  // Light Green
const Color buttonTextColor = Colors.white;
//const Color appBarTextColor = Colors.white;
//const Color appBarBackgroundColor = Color(0xFF2C2C2C);
//const Color bottomNavBarColor = Color(0xFF2C2C2C);
const Color selectedNavBarItemColor = Colors.white;
  return ThemeData(
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.normal),
      bodyLarge: GoogleFonts.roboto(fontSize: 16.0),
      labelLarge: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.bold),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      titleTextStyle: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.normal, color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      hintStyle: GoogleFonts.poppins(color: primaryColor, fontSize: 14.0, fontWeight: FontWeight.w500),
      labelStyle: GoogleFonts.poppins(color: Colors.blueAccent, fontSize: 14.0, fontWeight: FontWeight.w500),
      errorStyle: const TextStyle(
        color: Colors.red,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(secondaryColor),  // Button background color
        foregroundColor: WidgetStateProperty.all(buttonTextColor),        // Button text color
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 12, horizontal: 28)),
        textStyle: WidgetStateProperty.all(
          GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w500),  // Button font style
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),  // Rounded corners for button
          ),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primaryColor,
      selectedItemColor: selectedNavBarItemColor,
      unselectedItemColor: Colors.grey[700],
      selectedLabelStyle: GoogleFonts.poppins(),
      unselectedLabelStyle: GoogleFonts.roboto(),
    ),
  );
}
