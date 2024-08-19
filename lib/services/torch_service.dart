import 'package:torch_light/torch_light.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

class TorchService {
  bool isTorchOn = false;
  bool isAudioPlaying = false;
  final String tableName = 'Control'; // Replace with your Airtable Table Name
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> fetchDataFromAirtable(String airtableAccessToken, String airtableBaseId) async {
    final url = 'https://api.airtable.com/v0/$airtableBaseId/$tableName?maxRecords=1&view=Grid%20view';
    if (airtableAccessToken.isNotEmpty && airtableBaseId.isNotEmpty) {
      print("Request sent");
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $airtableAccessToken',
        },
      );

      print(response);
      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final flashlightStatus = data['records'][0]['fields']['Flashlight Status']; // Replace 'Flashlight Status' with the actual field name
        final audioControl = data['records'][0]['fields']['Audio Control']; // Replace 'Audio Control' with the actual field name

        if (flashlightStatus == 'ON' || flashlightStatus == 'On' || flashlightStatus == 'on') {
          enableTorch();
          isAudioPlaying = false;
        } else {
          disableTorch();
          isAudioPlaying = false;
          isTorchOn = false;
        }

        if (flashlightStatus == 'PLAY' || flashlightStatus == 'Play' || flashlightStatus == 'play') {
          playAudio();
          isTorchOn = false;
        } else {
          stopAudio();
          isTorchOn = false;
        }
      }
    }
  }

  Future<void> enableTorch() async {
    try {
      await TorchLight.enableTorch();
      isTorchOn = true;
    } catch (e) {
      print('Could not enable torch: $e');
    }
  }

  Future<void> disableTorch() async {
    try {
      await TorchLight.disableTorch();
      isTorchOn = false;
    } catch (e) {
      print('Could not disable torch: $e');
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
      await _audioPlayer.play(AssetSource('music/ringtone.mp3')); // Play audio from assets folder
    } catch (e) {
      print('Could not play audio: $e');
    }
  }

  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop(); // Stop audio playback
      isAudioPlaying = false;
    } catch (e) {
      print('Could not stop audio: $e');
    }
  }
}
