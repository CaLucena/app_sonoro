import 'dart:convert';
import 'package:http/http.dart' as http;

class DecibelService {
  final String endpoint = "https://apps.roboticaeteavs.com.br/decibeis/listarDecibeis";

  Future<List<dynamic>> getDados() async {
    final uri = Uri.parse(endpoint);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
