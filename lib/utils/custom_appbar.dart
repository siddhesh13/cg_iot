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
    final textStyle = appBarTheme.titleTextStyle ?? const TextStyle(color: Colors.white);

    return AppBar(
      title: Text(
        title,
        style: textStyle, // Use the text style from the app theme with white color
      ),
      centerTitle: true, // Center the title
      backgroundColor: appBarTheme.backgroundColor ?? Colors.black, // Use the background color from the app theme
      iconTheme: const IconThemeData(color: Colors.white), // Set the icon color to white
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu), // Hamburger icon
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Opens the drawer when pressed
            },
          );
        },
      ),
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
