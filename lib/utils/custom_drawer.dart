import 'package:cg_iot/screens/contact_screen.dart';
import 'package:flutter/material.dart';
import '../screens/about_us_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black, // Set drawer background to black
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black, // Keep the header background black
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png', // Replace with your logo path
                    height: 80.0, // Adjust the height as needed
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'CG IoT App',
                    style: TextStyle(
                      color: Colors.white, // White text color
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.white), // White icon color
              title: const Text(
                'About the App',
                style: TextStyle(color: Colors.white), // White text color
              ),
              onTap: () {
                // Close the drawer and navigate
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.white), // White icon color
              title: const Text(
                'Contact',
                style: TextStyle(color: Colors.white), // White text color
              ),
              onTap: () {
                // Close the drawer and navigate
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUsPage()), // Replace with actual Contact page later
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
