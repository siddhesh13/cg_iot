import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class BrightnessScreen extends StatefulWidget {
  const BrightnessScreen({super.key});

  @override
  _BrightnessScreenState createState() => _BrightnessScreenState();
}

class _BrightnessScreenState extends State<BrightnessScreen> {
  double _brightness = 0.5;
  Timer? _timer;
  String _thingspeakApiKey = "";
  bool _isUploadingEnabled = false;

  @override
  void initState() {
    super.initState();
    _getBrightness();
    _startBrightnessUpdate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _getBrightness() async {
    double brightness;
    try {
      brightness = await ScreenBrightness().current;
    } catch (e) {
      brightness = 0.5;
    }
    setState(() {
      _brightness = brightness;
    });
  }

  Future<void> _setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      // Handle error
    }
  }

  void _startBrightnessUpdate() {
    // Real-time brightness update
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _getBrightness(); // Update the brightness in real-time
    });

    // Upload brightness to ThingSpeak every 1 minute
    Timer.periodic(const Duration(minutes: 1), (Timer t) async {
      if (_isUploadingEnabled && _thingspeakApiKey.isNotEmpty) {
        await _uploadBrightnessToThingSpeak();
      }
    });
  }

  Future<void> _uploadBrightnessToThingSpeak() async {
    final url = Uri.parse('https://api.thingspeak.com/update?api_key=$_thingspeakApiKey&field1=${(_brightness * 100).toInt()}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Brightness uploaded to ThingSpeak');
      } else {
        print('Failed to upload brightness to ThingSpeak');
      }
    } catch (e) {
      print('Error uploading brightness to ThingSpeak: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen Brightness',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent, // Set AppBar color
      ),
      body: SingleChildScrollView(  // Make the screen scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.brightness_6,
                size: 100,
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              Text(
                'Brightness: ${(_brightness * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 24),
              ),
              /*Slider(
                value: _brightness,
                min: 0.0,
                max: 1.0,
                divisions: 100,
                label: '${(_brightness * 100).toStringAsFixed(0)}%',
                onChanged: (double value) {
                  setState(() {
                    _brightness = value;
                  });
                  _setBrightness(value);
                },
              ),*/
              const SizedBox(height: 40),
              TextField(
                decoration: InputDecoration(
                  labelText: 'ThingSpeak API Key',
                  border: OutlineInputBorder(), // Add border to text field
                ),
                onChanged: (value) {
                  setState(() {
                    _thingspeakApiKey = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text("Enable ThingSpeak Uploading"),
                value: _isUploadingEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _isUploadingEnabled = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
