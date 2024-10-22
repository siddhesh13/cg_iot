import 'package:cg_iot/utils/custom_appbar.dart';
import 'package:cg_iot/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/torch_service.dart';
import '../utils/custom_snackbar.dart';
import 'dart:async';

class FlashlightScreen extends StatefulWidget {
  const FlashlightScreen({super.key});

  @override
  _FlashlightScreenState createState() => _FlashlightScreenState();
}

class _FlashlightScreenState extends State<FlashlightScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  late TorchService torchService;
  Timer? _timer;
  bool isPollingEnabled = false;
  String airtableAccessToken = '';
  String airtableBaseId = '';
  bool isShadowEnabled = false; // Add this variable to manage shadow state
  // Add TextEditingControllers
  late TextEditingController _airtableAccessTokenController;
  late TextEditingController _airtableBaseIdController;
  bool isPressed = false;
  
  @override
  void initState() {
    super.initState();
    torchService = TorchService(scaffoldMessengerKey: _scaffoldMessengerKey);
    _airtableAccessTokenController = TextEditingController();
    _airtableBaseIdController = TextEditingController();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      airtableAccessToken = prefs.getString('airtableAccessToken') ?? '';
      airtableBaseId = prefs.getString('airtableBaseId') ?? '';

      // Set initial values to controllers
      _airtableAccessTokenController.text = airtableAccessToken;
      _airtableBaseIdController.text = airtableBaseId;
    });

    if (isPollingEnabled && _areCredentialsValid()) {
      _startInitialFetch();
    }
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('airtableAccessToken', airtableAccessToken);
    await prefs.setString('airtableBaseId', airtableBaseId);
  }

  bool _areCredentialsValid() {
    return airtableAccessToken.isNotEmpty && airtableBaseId.isNotEmpty;
  }

  void _startInitialFetch() async {
    showSnackBar(context, 'Request sent to Airtable');
    try {
      String statusMessage = await torchService.fetchDataFromAirtable(airtableAccessToken, airtableBaseId);
      showSnackBar(context, statusMessage);
    } catch (e) {
      showSnackBar(context, 'Error fetching data: $e');
    }
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer t) async {
      if (!_areCredentialsValid()) {
        showSnackBar(context, 'Invalid credentials');
        _togglePolling(false); // Stop polling
        return;
      }
      try {
        String statusMessage = await torchService.fetchDataFromAirtable(airtableAccessToken, airtableBaseId);
        // Use setState to update UI when torch state changes
      setState(() {});
        if (statusMessage.toLowerCase() != 'ok') {
          showSnackBar(context, statusMessage);
        }
      } catch (e) {
        showSnackBar(context, 'Error during polling: $e');
        _togglePolling(false); // Stop polling on error
      }
    });
  }

  void _togglePolling(bool value) {
    setState(() {
      isPollingEnabled = value;
    });

    if (isPollingEnabled) {
      if (_areCredentialsValid()) {
        _startPolling();
      } else {
        showSnackBar(context, 'Please provide Airtable Access Token and Base ID before updating.');
        _togglePolling(false); // Disable polling if credentials are invalid
      }
    } else {
      _stopPolling();
    }
  }

  void _stopPolling() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    // Dispose controllers when the screen is disposed
    _airtableAccessTokenController.dispose();
    _airtableBaseIdController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _toggleShadow() {
    setState(() {
      isShadowEnabled = !isShadowEnabled; // Toggle the shadow state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: CustomAppBar(
         title: 'Flashlight',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(
        torchService.isTorchOn
            ? Icons.flashlight_on
            : Icons.flashlight_off,
        color: torchService.isTorchOn ? Colors.yellow : Colors.grey,
        size: 80,
      ),
            const SizedBox(height: 10),
            Text(
              torchService.isTorchOn ? 'Torch is ON' : 'Torch is OFF',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 25),
            CustomTextField(
              controller: _airtableAccessTokenController,
              label: 'Airtable Access Token',
              onChanged: (value) {
                setState(() {
                  airtableAccessToken = value;
                });
                _saveCredentials(); // Save immediately when changed
              },
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _airtableBaseIdController,
              label: 'Airtable Base ID',
              onChanged: (value) {
                setState(() {
                  airtableBaseId = value;
                });
                _saveCredentials(); // Save immediately when changed
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  _togglePolling(!isPollingEnabled);
                  isPressed = !isPressed; // Toggle button state
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPressed ? Color(0xFF4CAF50): Color(0xFF30B635), // Toggle color
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  elevation: 5, // Add some elevation for the 3D effect
                ),
                child: const Text("Update"),
              ),
          ],
        ),
      ),
    );
  }
}
