import 'package:flutter/material.dart';
import '../services/torch_service.dart';
import '../widgets/torch_toggle_button.dart';
import 'dart:async';

class FlashlightScreen extends StatefulWidget {
  @override
  _FlashlightScreenState createState() => _FlashlightScreenState();
}

class _FlashlightScreenState extends State<FlashlightScreen> {
  final TorchService torchService = TorchService();
  Timer? _timer;
  bool isPollingEnabled = false;
  String airtableAccessToken = '';
  String airtableBaseId = '';
  @override
  void initState() {
    super.initState();
    _startInitialFetch();
  }

  void _startInitialFetch() async {
    await torchService.fetchDataFromAirtable(airtableAccessToken, airtableBaseId);
  }

  void _togglePolling(bool value) {
    setState(() {
      isPollingEnabled = value;
    });

    if (isPollingEnabled) {
      _startPolling();
    } else {
      _stopPolling();
    }
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 30), (Timer t) async {
      await torchService.fetchDataFromAirtable(airtableAccessToken, airtableBaseId);
      setState(() {
       
      }); // Update UI if necessary
    });
  }

  void _stopPolling() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashlight',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent, // Set AppBar color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TorchToggleButton(torchService: torchService),
            SizedBox(height: 20),
            Text(
              torchService.isTorchOn ? 'Torch is ON' : 'Torch is OFF',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            
            TextField(
              decoration: InputDecoration(
                labelText: 'Airtable Access Token',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  airtableAccessToken = value;
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Airtable Base ID',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  airtableBaseId = value;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Polling Enabled'),
                Switch(
                  value: isPollingEnabled,
                  onChanged: (value) {
                    _togglePolling(value);
                  },
                ),
                // Icon to represent audio status
            Icon(
              torchService.isAudioPlaying ? Icons.music_note : Icons.music_off,
              size: 30,
              color: torchService.isAudioPlaying ? Colors.green : Colors.red,
            ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
