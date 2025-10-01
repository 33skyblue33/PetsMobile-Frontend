import 'dart:convert';
import 'package:http/http.dart' as http;
import 'apiConfig.dart'; 
import 'models/pet.dart';
import 'models/petRequest.dart';

Future<List<Pet>> fetchPets() async {
  final uri = Uri.parse('${ApiConfig.baseUrl}/Pets');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Pet.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load pets');
  }
}

Future<Pet> createPet(PetRequest petRequest, String accessToken) async {
  final uri = Uri.parse('${ApiConfig.baseUrl}/Pets');
  
  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode(petRequest.toJson()),
  );

  if (response.statusCode == 201) {
    return Pet.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create pet. Status: ${response.statusCode}');
  }
}

Future<void> deletePet(int petId, String accessToken) async {
  final uri = Uri.parse('${ApiConfig.baseUrl}/Pets/$petId');
  
  final response = await http.delete(
    uri,
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode != 204) {
    throw Exception('Failed to delete pet. Status: ${response.statusCode}');
  }
}

Future<void> updatePet(int petId, PetRequest petRequest, String accessToken) async {
  final uri = Uri.parse('${ApiConfig.baseUrl}/Pets/$petId');
  
  final response = await http.put(
    uri,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode(petRequest.toJson()),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update pet. Status code: ${response.statusCode}');
  }
}