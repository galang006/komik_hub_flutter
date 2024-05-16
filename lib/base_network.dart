import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseNetwork {
  static final String baseUrl = "https://mangaverse-api.p.rapidapi.com/manga";

  static Future<Map<String, dynamic>> get(String partUrl) async {
    final String fullUrl = baseUrl + partUrl;
    debugPrint("BaseNetwork - fullUrl : $fullUrl");

    final headers = {
      //'X-RapidAPI-Key': '54783c9b68mshcba9b7aef779a18p17a6a7jsn115a58dc1f34',
      //'X-RapidAPI-Key': '84cb9e3cc0mshbb407e0ce7ac26cp10601ejsn7427c13b53a8',
      'X-RapidAPI-Key': 'b53bb91f8amsh6407729f528c092p1e9773jsne59c6c7be581',
      'X-RapidAPI-Host': 'mangaverse-api.p.rapidapi.com'
    };

    final response = await http.get(Uri.parse(fullUrl), headers: headers);
    debugPrint("BaseNetwork - response : ${response.body}");
    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> _processResponse(
      http.Response response) async {
    final body = response.body;
    if (body.isNotEmpty) {
      final jsonBody = json.decode(body);
      return jsonBody;
    } else {
      print("processResponse error");
      return {"error": true};
    }
  }

  static void debugPrint(String value) {
    print("[BASE_NETWORK] - $value");
  }
}