import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  final String email = 'workshops@curiositygym.com';
  final String websiteUrl = 'https://www.curiositygym.com';
/*
  void _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch $email';
    }
  }

  void _launchWebsite(String url) async {
    final Uri websiteLaunchUri = Uri.parse(url);
    if (await canLaunchUrl(websiteLaunchUri)) {
      await launchUrl(websiteLaunchUri);
    } else {
      throw 'Could not launch $url';
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get in Touch',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
  children: [
    const Icon(Icons.email),
    const SizedBox(width: 10),
    Flexible( // Ensures the text adjusts within the available space
      child: GestureDetector(
        // onTap: () => _launchEmail(email),
        child: Text(
          email,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 16,
            decoration: TextDecoration.underline,
          ),
          overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
        ),
      ),
    ),
  ],
),
const SizedBox(height: 20),
Row(
  children: [
    const Icon(Icons.web),
    const SizedBox(width: 10),
    Flexible( // Ensures the text adjusts within the available space
      child: GestureDetector(
        // onTap: () => _launchWebsite(websiteUrl),
        child: Text(
          websiteUrl,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 16,
            decoration: TextDecoration.underline,
          ),
          overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
        ),
      ),
    ),
  ],
)

          ],
        ),
      ),
    );
  }
}
