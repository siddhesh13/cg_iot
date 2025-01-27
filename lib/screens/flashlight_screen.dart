import 'package:cg_iot/utils/custom_appbar.dart';
import 'package:cg_iot/utils/custom_drawer.dart';
import 'package:cg_iot/widgets/custom_text_field.dart';
import 'package:cg_iot/widgets/info_button.dart';
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

class _FlashlightScreenState extends State<FlashlightScreen> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final GlobalKey _iconKey = GlobalKey(); // Key to get the icon's position
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
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    torchService = TorchService(scaffoldMessengerKey: _scaffoldMessengerKey);
    _airtableAccessTokenController = TextEditingController();
    _airtableBaseIdController = TextEditingController();
    _loadCredentials();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
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
/*
  AnimatedIconData? _getAnimatedIcon() {
  if (torchService.isAudioPlaying) {
    _animationController.repeat(); // Loop animation for the ringer
    return AnimatedIcons.play_pause; // Example animated icon for ringer
  } else {
    _animationController.stop(); // Stop animation when not playing
    return null; // No animated icon when not in audio mode
  }
}
*/
 Widget _buildIcon() {
  if (torchService.isAudioPlaying) {
    // Return a widget displaying the GIF
    return Image.asset(
      'assets/images/ringeriot.gif', // Replace with the actual path to your GIF
      width: 100, // Adjust size as needed
      height: 100, // Adjust size as needed
      fit: BoxFit.contain, // Ensure the image scales properly
    );
  } else {
    // Return a normal icon for the flashlight
    return Icon(
      torchService.isTorchOn ? Icons.flashlight_on : Icons.flashlight_off,
      size: 100, // Adjust size as needed
      color: torchService.isTorchOn ? Colors.yellow : Colors.grey, // Adjust colors
    );
  }
}
/*
Color _getIconColor() {
  // Check torchService's state to return the appropriate color
  if (torchService.isTorchOn) {
    return Colors.yellow; // Color for the flashlight on
  } else if (torchService.isAudioPlaying) {
    return Colors.orange; // Color for the ringer icon
  } else {
    return Colors.grey; // Color for the flashlight off
  }
}
*/
String _getIconStatus() {
  // Check torchService's state to return the appropriate color
  if (torchService.isTorchOn) {
    return "Flashlight is ON"; // Color for the flashlight on
  } else if (torchService.isAudioPlaying) {
    return ""; // Color for the ringer icon
  } else {
    return "Flashlight is OFF"; // Color for the flashlight off
  }
}

  @override
  void dispose() {
    // Dispose controllers when the screen is disposed
    _airtableAccessTokenController.dispose();
    _airtableBaseIdController.dispose();
    _timer?.cancel();
    super.dispose();
    _animationController.dispose();
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
      drawer: CustomDrawer(), // Add the custom drawer here
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _buildIcon(),
            ),
            const SizedBox(height: 10),
            Text(
              _getIconStatus(),
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _airtableAccessTokenController,
                    label: 'Airtable Access Token',
                    suffixIcon:InfoButton(
                      message: 'Airtable Access Token: Enter your unique API Key (from your Airtable account under API settings.) for authentication and access.',
                      topOffset: 195, // Adjust the top position dynamically
                    ), 
                    onChanged: (value) {
                      setState(() {
                        airtableAccessToken = value;
                      });
                      _saveCredentials(); // Save immediately when changed
                    },
                  ),
                  
                ),
               
              ]
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                child: CustomTextField(
                  controller: _airtableBaseIdController,
                  label: 'Airtable Base ID',
                  suffixIcon: InfoButton(
                 message: 'Airtable Base ID: Input the Base ID  (from your Airtable account under API settings.) to connect to your specific data set.',
                      topOffset: 125, // Adjust the top position dynamically
                    ),
                  onChanged: (value) {
                    setState(() {
                      airtableBaseId = value;
                    });
                    _saveCredentials(); // Save immediately when changed
                  },
                ),
                ),
                
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  if(_areCredentialsValid()){
                    showSnackBar(context, 'Credentials Updated');
                  }
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
              const SizedBox(height: 8), // Add spacing below the button
            
          ],
        ),
      ),
    );
  }
}
