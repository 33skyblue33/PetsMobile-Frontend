import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'apiConfig.dart';
import 'models/pet.dart';
import 'models/petRequest.dart';
import 'models/pagedResult.dart';
import 'models/rating.dart';
import 'models/ratingRequest.dart';

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

Future<void> createPet(PetRequest petRequest, File imageFile, String accessToken) async {
  final uri = Uri.parse('${ApiConfig.baseUrl}/Pets');
  var request = http.MultipartRequest('POST', uri)
    ..headers['Authorization'] = 'Bearer $accessToken';

  request.fields['Name'] = petRequest.name;
  request.fields['Color'] = petRequest.color;
  request.fields['Age'] = petRequest.age.toString();
  request.fields['Description'] = petRequest.description;
  request.fields['BreedId'] = petRequest.breedId.toString();

  request.files.add(await http.MultipartFile.fromPath('Image', imageFile.path));

  final response = await request.send();

  if (response.statusCode != 201) {
    throw Exception('Failed to create pet. Status: ${response.statusCode}');
  }
}

Future<void> updatePet(int petId, PetRequest petRequest, File? imageFile, String accessToken) async {
  final uri = Uri.parse('${ApiConfig.baseUrl}/Pets/$petId');
  var request = http.MultipartRequest('PUT', uri)
    ..headers['Authorization'] = 'Bearer $accessToken';

  request.fields['Name'] = petRequest.name;
  request.fields['Color'] = petRequest.color;
  request.fields['Age'] = petRequest.age.toString();
  request.fields['Description'] = petRequest.description;
  request.fields['BreedId'] = petRequest.breedId.toString();

  if (imageFile != null) {
    request.files.add(await http.MultipartFile.fromPath('Image', imageFile.path));
  }

  final response = await request.send();

  if (response.statusCode != 200) {
    throw Exception('Failed to update pet. Status code: ${response.statusCode}');
  }
}

Future<void> deletePet(int petId, String accessToken) async {
  final uri = Uri.parse('${ApiConfig.baseUrl}/Pets/$petId');
  final response = await http.delete(
    uri,
    headers: {'Authorization': 'Bearer $accessToken'},
  );

  if (response.statusCode != 204) {
    throw Exception('Failed to delete pet. Status: ${response.statusCode}');
  }
}

Future<PagedResult<Rating>> fetchPetRatings({
  required int petId,
  int? pointer, 
  int pageSize = 10,
}) async {
  final queryParameters = <String, String>{
    'pageSize': pageSize.toString(),
  };
  if (pointer != null) {
    queryParameters['pointer'] = pointer.toString();
  }

  final uri = Uri.parse('${ApiConfig.baseUrl}/Pets/$petId/Ratings')
      .replace(queryParameters: queryParameters);
      
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    return PagedResult.fromJson(json, Rating.fromJson);
  } else {
    throw Exception('Failed to load ratings for pet $petId');
  }
}

Future<Rating> addRatingForPet({
  required int petId,
  required RatingRequest ratingRequest,
  required String accessToken,
}) async {
  final uri = Uri.parse('${ApiConfig.baseUrl}/Pets/$petId/Ratings');

  final response = await http.post(
    uri,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(ratingRequest.toJson()),
  );

  if (response.statusCode == 201) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    return Rating.fromJson(json);
  } else {
    throw Exception('Failed to add rating. Status: ${response.statusCode}');
  }
}