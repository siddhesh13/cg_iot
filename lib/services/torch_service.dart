// lib/services/torch_service.dart
import 'package:torch_flashlight/torch_flashlight.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TorchService {
  bool isTorchOn = false;
  //final String airtableApiKey = 'patER6aE4tFV8XV3r.f0852056bb2779528e9b47f1f06265929ca9caf47f4474f61e22e41c7354f3b6'; // Replace with your Airtable Personal Access Token
  //final String baseId = 'appH9orgDhY8wXZCn'; // Replace with your Airtable Base ID
  final String tableName = 'Control'; // Replace with your Airtable Table Name

  Future<void> fetchDataFromAirtable(String airtableAccessToken, String airtableBaseId) async {
    final url = 'https://api.airtable.com/v0/$airtableBaseId/$tableName?maxRecords=1&view=Grid%20view';
    if(airtableAccessToken.isNotEmpty && airtableBaseId.isNotEmpty){
    print("request sent");
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
      final cellValue = data['records'][0]['fields']['Flashlight Status']; // Replace 'YOUR_FIELD_NAME' with the actual field name

      if (cellValue == 'ON' || cellValue == 'On' || cellValue == 'on') {
        enableTorch();
      } else {
        disableTorch();
      }
    }
    }
  }

  Future<void> enableTorch() async {
    try {
      await TorchFlashlight.enableTorchFlashlight();
      isTorchOn = true;
    } catch (e) {
      print('Could not enable torch: $e');
    }
  }

  Future<void> disableTorch() async {
    try {
      await TorchFlashlight.disableTorchFlashlight();
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
}
