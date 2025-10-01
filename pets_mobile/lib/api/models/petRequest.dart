class PetRequest {
  final String name;
  final String color;
  final int age;
  final String imageUrl;
  final String description;
  final int breedId;

  PetRequest({
    required this.name,
    required this.color,
    required this.age,
    required this.imageUrl,
    required this.description,
    required this.breedId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color,
      'age': age,
      'imageUrl': imageUrl,
      'description': description,
      'breedId': breedId,
    };
  }
}
