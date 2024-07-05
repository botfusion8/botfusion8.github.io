import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/slammie_bot_response.dart';

class ApiService {
  static const String _url = 'https://fusionflow.maslow.ai/api/v1/prediction/4bddea5e-c392-4dbe-bd05-3ef2aa60942d';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer vWxybfzjsUPjB2i4+/uoLrC6BMxvfXUD71o8hZWnf9Y=',
  };

  Future<SlammieBotResponse> slammieChatBot(String message) async {
    final Uri uri = Uri.parse(_url);

    final Map<String, dynamic> jsonBody = {
      "question": message,
      "overrideConfig": {
        "disableFileDownload": true
      }
    };

    final response = await http.post(
      uri,
      headers: _headers,
      body: json.encode(jsonBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return SlammieBotResponse.fromJson(responseData);

    } else {
      throw Exception('Failed to send request: ${response.statusCode}\nResponse: ${response.body}');
    }
  }
}