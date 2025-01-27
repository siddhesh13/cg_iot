import 'package:cg_iot/utils/custom_appbar.dart';
import 'package:cg_iot/utils/custom_drawer.dart';
import 'package:cg_iot/utils/custom_snackbar.dart';
import 'package:cg_iot/widgets/custom_text_field.dart';
import 'package:cg_iot/widgets/info_button.dart';
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
  double brightnessValue = 0.5; 

  String _thingspeakApiKey = "";
  bool _isUploadInProgress = false;
  bool _isSensorAvailable = true;

  // For debouncing
  Timer? _debounceTimer;
  static const Duration debounceDuration = Duration(milliseconds: 300);
  static const Duration rateLimitDuration = Duration(seconds: 10);
  Timer? _rateLimitTimer;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _startAmbientLightSensor();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _timer?.cancel();
    _controller.dispose();  // Dispose of the controller
    _debounceTimer?.cancel();
    _rateLimitTimer?.cancel();
    super.dispose();
  }

  void _startAmbientLightSensor() {
    try {
      _ambientLightSensor = AmbientLight();
      _subscription = _ambientLightSensor?.ambientLightStream.listen((luxValue) {
        setState(() {
          _ambientLight = luxValue;
          brightnessValue = _mapBrightnessValue(_ambientLight);
          //print(brightnessValue);
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

  void _uploadToCloud() async {
    if (_isUploadInProgress) return;

    // Debounce
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, () async {
      if (_rateLimitTimer?.isActive ?? false) return; // Check if rate limit timer is active

      setState(() {
        _isUploadInProgress = true;
      });

      try {
        if(_thingspeakApiKey.isNotEmpty){
        // Upload ambient light data to ThingSpeak
        final luxValue = _ambientLight.toInt();
        final url = Uri.parse(
            'https://api.thingspeak.com/update?api_key=$_thingspeakApiKey&field1=$luxValue');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          showSnackBar(context, "Data uploaded successfully!");
        } else {
          showSnackBar(context, "Error: Failed to upload data");
        }

        // Start rate limit timer
        _rateLimitTimer = Timer(rateLimitDuration, () {
          setState(() {
            _isUploadInProgress = false;
          });
        });
        }
        else{
          showSnackBar(context, "Please provide Thingspeak API key before uploading.");
          _isUploadInProgress=false;
        }
      } catch (e) {
        showSnackBar(context, 'Error: $e');
        setState(() {
          _isUploadInProgress = false;
        });
      }
    });
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _thingspeakApiKey = prefs.getString('thingspeakApiKey') ?? '';
      _controller.text = _thingspeakApiKey;  // Load the saved API key into the controller
    });
  }

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('thingspeakApiKey', _thingspeakApiKey);
  }

  Color _getIconColor(double value) {
    // Map the brightness value to a color intensity
    // For example: 0.0 is dark and 1.0 is bright
    return Color.lerp(Colors.grey, Colors.orange, value)!;
  }
  double _mapBrightnessValue(double value) {
  // Clamp the value to ensure it's within the expected range (0–1000)
  double clampedValue = value.clamp(0, 2000);
  
  // Map the value to a 0.0–1.0 range
  return clampedValue / 2000.0;
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Ambient Light"
      ),
      drawer: CustomDrawer(), 
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Icon(
                Icons.lightbulb_outline,
                size: 100,
                color: _getIconColor(brightnessValue),
              ),
              const SizedBox(height: 20),
              Text(
                _isSensorAvailable
                    ? 'Ambient Light Intensity: ${_ambientLight.toStringAsFixed(0)}'
                    : 'Ambient light sensor not available',
                style: TextStyle(fontSize: 22.0,),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: _controller,
                label: 'ThingSpeak API Key',
                suffixIcon: InfoButton(
                message: 'Provide your ThingSpeak API Key ( under Channel settings) to enable data uploads to the cloud.',
                topOffset: 125,
              ),
                onChanged: (value) {
                  setState(() {
                    _thingspeakApiKey = value;
                  });
                  _savePreferences();
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:_isUploadInProgress ? null : _uploadToCloud,
                
                child: _isUploadInProgress
                    ? const CircularProgressIndicator()
                    : const Text("Upload", style: TextStyle(fontSize: 18,color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}
