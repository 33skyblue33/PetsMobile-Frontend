import 'package:pets_mobile/api/apiConfig.dart';

class Pet {
  final int id;
  final String name;
  final String color;
  final int age;
  final String imageUrl;
  final String description;
  final double averageRating;
  final String breedName;
  final String breedDescription;

  const Pet({
    required this.id,
    required this.name,
    required this.color,
    required this.age,
    required this.imageUrl,
    required this.description,
    required this.averageRating, 
    required this.breedName,
    required this.breedDescription,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    String relativeUrl = json['imageUrl'];

    return Pet(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      age: json['age'],
      imageUrl: '${ApiConfig.imageBaseUrl}$relativeUrl',
      description: json['description'],
      averageRating: (json['averageRating'] as num).toDouble(), 
      breedName: json['breedName'],
      breedDescription: json['breedDescription'],
    );
  }
}