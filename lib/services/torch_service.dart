import 'package:torch_light/torch_light.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TorchService {
  bool isTorchOn = false;
  final String tableName = 'Control'; // Replace with your Airtable Table Name

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
        final cellValue = data['records'][0]['fields']['Flashlight Status']; // Replace 'Flashlight Status' with the actual field name

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
}
