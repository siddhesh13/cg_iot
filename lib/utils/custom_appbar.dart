import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;

  // Constructor to accept title and actions as parameters
  CustomAppBar({required this.title, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    // Access the app theme
    final appBarTheme = Theme.of(context).appBarTheme;
    final textStyle = appBarTheme.titleTextStyle ?? const TextStyle();

    return AppBar(
      title: Text(
        title,
        style: textStyle, // Use the text style from the app theme
      ),
      backgroundColor: appBarTheme.backgroundColor ?? Colors.black, // Use the background color from the app theme
      actions: [
        IconButton(
          icon: Image.asset(
            'assets/images/logo.png', // Replace with your image asset
            height: 40.0, // Adjust the height as needed
          ),
          onPressed: () {
            // Define your action here
          },
        ),
        const SizedBox(width: 6.0), // Add some spacing between the image and the right edge
        ...actions, // Spread the additional actions
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
