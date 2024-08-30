import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart'; // Import the vibration package


class TorchService {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  TorchService({required this.scaffoldMessengerKey});
  bool isTorchOn = false;
  bool isAudioPlaying = false;
  final String tableName = 'Control'; // Replace with your Airtable Table Name
  final AudioPlayer _audioPlayer = AudioPlayer();


  // Helper method to show SnackBar using the ScaffoldMessengerKey
  void showSnackBar(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  Future<String> fetchDataFromAirtable(String airtableAccessToken, String airtableBaseId) async {
    final url = 'https://api.airtable.com/v0/$airtableBaseId/$tableName?maxRecords=1&view=Grid%20view';
    
    if (airtableAccessToken.isEmpty || airtableBaseId.isEmpty) {
      return 'Invalid Airtable credentials';
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $airtableAccessToken',
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {
        // Handle request timeout
        return http.Response('Request Timeout', 408);
      });

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          final flashlightStatus = data['records'][0]['fields']['Flashlight Status']; // Replace with the actual field name
          if(flashlightStatus!=null){
          String statusMessage = 'No action taken';
          
          if (flashlightStatus.toLowerCase() == 'on') {
            await enableTorch();
            isAudioPlaying = false;
            statusMessage = 'ok';
          } else{
            await disableTorch();
            isAudioPlaying = false;
            isTorchOn = false;
            statusMessage = 'ok';
          }

          if (flashlightStatus.toLowerCase() == 'play') {
            await playAudio();
            isTorchOn = false;
            statusMessage = 'ok';
          } else{
            await stopAudio();
            isAudioPlaying = false;
            statusMessage = 'ok';
          }

          return statusMessage;
          }else{
            return "ok";
          }
        } catch (e) {
          return 'Error parsing response data: ${e.toString()}';
        }
      } else if (response.statusCode == 429) {
        return 'Rate limit exceeded. Please try again later.';
      } else if (response.statusCode == 403 || response.statusCode == 404) {
        return 'Invalid API Key or Base ID. Please check your Airtable credentials.';
      } else {
        return 'Error: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } on SocketException {
      return 'Network error. Please check your internet connection.';
    } on FormatException {
      return 'Malformed URL. Please check the URL format.';
    } on TimeoutException {
      return 'Request timed out. Please try again later.';
    } catch (e) {
      return 'Unexpected error: ${e.toString()}';
    }
  }


  Future<void> enableTorch() async {
    try {
      if (await TorchLight.isTorchAvailable()) {
        await TorchLight.enableTorch();
        isTorchOn = true;
      } else {
        showSnackBar('Torch is not available on this device.');
      }
    } catch (e) {
      if (e.toString().contains('TorchCurrentlyInUse')) {
        showSnackBar('Torch is currently in use by another application.');
      } else {
        showSnackBar('Could not enable torch: $e');
      }
    }
  }

  Future<void> disableTorch() async {
    try {
      if (await TorchLight.isTorchAvailable()) {
        await TorchLight.disableTorch();
        isTorchOn = false;
      } else {
        showSnackBar('Torch is not available on this device.');
      }
    } catch (e) {
      if (e.toString().contains('TorchCurrentlyInUse')) {
        showSnackBar('Torch is currently in use by another application.');
      } else {
        showSnackBar('Could not disable torch: $e');
      }
    } 
  }


  Future<void> toggleTorch() async {
    if (isTorchOn) {
      await disableTorch();
    } else {
      await enableTorch();
    }
  }

  Future<void> playAudio() async {
  try {
    isAudioPlaying = true;
    
    if (Platform.isIOS) {
      await _audioPlayer.play(AssetSource('music/ringtone.mp3')); // Play iOS-specific audio file
    } else {
      await _audioPlayer.play(AssetSource('music/android.mp3')); // Play audio for other platforms (Android, etc.)
    }
    // Vibrate the phone if vibration is available
      if ((await Vibration.hasVibrator()) == true) {
  Vibration.vibrate();
} else {
  // Handle the case where the device does not have a vibrator or the result is null
  showSnackBar('This device does not support vibration.');
}
  } catch (e) {
    showSnackBar('Could not play audio: $e');
  }
}

  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop(); // Stop audio playback
      isAudioPlaying = false;
    } catch (e) {
      //print('Could not stop audio: $e');
      showSnackBar('Could not stop audio: $e');
    }
    try {
    if ((await Vibration.hasVibrator()) == true) {
      Vibration.cancel();  // Stop the vibration
    } else {
      showSnackBar('This device does not support vibration.');
    }
  } catch (e) {
    showSnackBar('Could not stop vibration: $e');
  }
  }
}
