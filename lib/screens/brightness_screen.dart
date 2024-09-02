import 'package:cg_iot/utils/custom_snackbar.dart';
import 'package:cg_iot/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:ambient_light/ambient_light.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BrightnessScreen extends StatefulWidget {
  const BrightnessScreen({super.key});

  @override
  _BrightnessScreenState createState() => _BrightnessScreenState();
}

class _BrightnessScreenState extends State<BrightnessScreen> {
  AmbientLight? _ambientLightSensor;
  StreamSubscription? _subscription;
  double _ambientLight = 0.0;
  Timer? _timer;
  String _thingspeakApiKey = "";
  bool _isUploadingEnabled = false;
  bool _isSensorAvailable = true;

  // Move the TextEditingController to the State
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _startAmbientLightSensor();
    _startAmbientLightUpdate();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _timer?.cancel();
    _controller.dispose();  // Dispose of the controller
    super.dispose();
  }

  void _startAmbientLightSensor() {
    try {
      _ambientLightSensor = AmbientLight();
      _subscription = _ambientLightSensor?.ambientLightStream.listen((luxValue) {
        setState(() {
          _ambientLight = luxValue;
        });
      }, onError: (error) {
        setState(() {
          _isSensorAvailable = false;
        });
        showSnackBar(context, "Error accessing ambient light sensor: $error");
      });
    } catch (e) {
      setState(() {
        _isSensorAvailable = false;
      });
      showSnackBar(context, "Ambient light sensor not available: $e");
    }
  }

  void _startAmbientLightUpdate() {
    // Upload ambient light data to ThingSpeak every 1 minute
    _timer = Timer.periodic(const Duration(seconds: 30), (Timer t) async {
      if (_isUploadingEnabled && _thingspeakApiKey.isNotEmpty) {
        String statusMessage = await _uploadAmbientLightToThingSpeak();
        showSnackBar(context, statusMessage);
      }
    });
  }

  Future<String> _uploadAmbientLightToThingSpeak() async {
    final url = Uri.parse(
        'https://api.thingspeak.com/update?api_key=$_thingspeakApiKey&field1=${_ambientLight.toInt()}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return "Data uploaded successfully!";
      } else {
        return "Error: Failed to upload data";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  bool _areCredentialsValid() {
    return _thingspeakApiKey.isNotEmpty;
  }

  void _enableUploading(bool value) {
    setState(() {
      _isUploadingEnabled = value;
    });
    _savePreferences();

    if (_isUploadingEnabled) {
      if (_areCredentialsValid()) {
        _startAmbientLightUpdate();
      } else {
        showSnackBar(context,
            'Please provide Thingspeak API Key before enabling uploading.');
        _enableUploading(false); // Disable polling if credentials are invalid
      }
    } else {
      _stopUploading();
    }
  }

  void _stopUploading() {
    _timer?.cancel();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _thingspeakApiKey = prefs.getString('thingspeakApiKey') ?? '';
      _isUploadingEnabled = prefs.getBool('isUploadingEnabled') ?? false;
      _controller.text = _thingspeakApiKey;  // Load the saved API key into the controller
    });
  }

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('thingspeakApiKey', _thingspeakApiKey);
    await prefs.setBool('isUploadingEnabled', _isUploadingEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambient Light', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lightbulb_outline,
                size: 100,
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              Text(
                _isSensorAvailable
                    ? 'Ambient Light: ${_ambientLight.toStringAsFixed(0)} lux'
                    : 'Ambient light sensor not available',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: _controller,  // Use the persistent controller
                label: 'ThingSpeak API Key',
                onChanged: (value) {
                  setState(() {
                    _thingspeakApiKey = value;
                  });
                  _savePreferences();
                },
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text("Enable Uploading"),
                value: _isUploadingEnabled,
                onChanged: (bool value) {
                  _enableUploading(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
