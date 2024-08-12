import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mic_stream/mic_stream.dart';
import 'dart:math';
import 'dart:async';

class MicrophoneScreen extends StatefulWidget {
  @override
  _MicrophoneScreenState createState() => _MicrophoneScreenState();
}

class _MicrophoneScreenState extends State<MicrophoneScreen> {
  double soundLevel = 0.0;
  Stream<Uint8List>? stream;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startListening();
  }

  void startListening() {
    stream = MicStream.microphone(
      audioSource: AudioSource.DEFAULT,
      sampleRate: 44100,
      channelConfig: ChannelConfig.CHANNEL_IN_MONO,
      audioFormat: AudioFormat.ENCODING_PCM_16BIT,
    );

    // Process the audio data every 10 seconds
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => updateDbLevel());
  }

  void updateDbLevel() async {
    List<int> audioSamples = [];
    await for (final data in stream!) {
      audioSamples.addAll(data);
      break;
    }

    double sum = 0;
    for (var sample in audioSamples) {
      sum += sample * sample;
    }

    double meanSquare = sum / audioSamples.length;
    double rms = sqrt(meanSquare);
    double dbLevel = 20 * log(rms);

    setState(() {
      soundLevel = dbLevel;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Microphone'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mic,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Sound Level: ${soundLevel.toStringAsFixed(2)} dB',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
