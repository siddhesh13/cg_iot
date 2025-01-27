import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About the App'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white, // Sets the icon color to white
          ),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This IoT app provides seamless remote control and data visualization functionalities through secured cloud services such as Airtable and ThingSpeak. It serves as a powerful tool for demonstrating IoT functionality in a user-friendly manner.',
                  style: TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20.0), // Add space between paragraphs
                Text(
                  'Flashlight:',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Users can control the device’s flashlight remotely (over the cloud) by entering a specific command in Airtable, i.e., typing "ON/OFF" for the flashlight into their personal Airtable using their secured credentials.',
                  style: TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20.0),
                Text(
                  'Ambient Light:',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  'This screen displays real-time ambient light levels detected by the light sensor of the phone. It supports data uploads to the cloud, allowing users to observe and analyze time-stamped light intensity trends. Graphical visualizations are accessible through the ThingSpeak cloud service using their secured credentials.',
                  style: TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
