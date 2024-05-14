import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseNetwork {
  static final String baseUrl = "https://mangaverse-api.p.rapidapi.com/manga";

  static Future<Map<String, dynamic>> get(String partUrl) async {
    final String fullUrl = baseUrl + "/" + partUrl;
    debugPrint("BaseNetwork - fullUrl : $fullUrl");

    final headers = {
      'X-RapidAPI-Key': '54783c9b68mshcba9b7aef779a18p17a6a7jsn115a58dc1f34', // replace with your RapidAPI key
      'X-RapidAPI-Host': 'mangaverse-api.p.rapidapi.com' // host header
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