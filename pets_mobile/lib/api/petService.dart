import 'models/pet.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Pet>> fetchPets() async {
  final response = await http.get(Uri.parse('http://10.250.230.140:5215/api/v3/Pets'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Pet.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load pets');
  }
}