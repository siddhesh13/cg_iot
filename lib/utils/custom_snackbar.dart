import 'package:flutter/material.dart';

// Define the showSnackBar function
void showSnackBar(BuildContext context, String message, {Color backgroundColor = Colors.red}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      backgroundColor: backgroundColor,
      /*behavior: SnackBarBehavior.floating, // Makes the SnackBar float above the content
      shape: RoundedRectangleBorder(       // Rounded corners
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(16),    // Margin around the SnackBar
      elevation: 10,                       // Shadow effect
      duration: const Duration(seconds: 3), // Duration the SnackBar is visible
      action: SnackBarAction(              // Add an action button
        label: 'UNDO',
        textColor: Colors.yellow,           // Color of the action text
        onPressed: () {
          // Code to execute when the action button is pressed
        },
      ),*/
    ),
  );
}
