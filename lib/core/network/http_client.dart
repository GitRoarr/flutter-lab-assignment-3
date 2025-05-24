import 'dart:convert';
import 'package:http/http.dart' as http;
import '../exceptions/network_exception.dart';

class CustomHttpClient {
  final http.Client _client = http.Client();

  Future<dynamic> get(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw NetworkException('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  void dispose() {
    _client.close();
  }
}
