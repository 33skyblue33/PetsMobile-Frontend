class Pet {
  final int id;
  final String name;
  final String color;
  final int age;
  final String imageUrl;
  final String description;
  final String breedName;
  final String breedDescription;

  const Pet({
    required this.id,
    required this.name,
    required this.color,
    required this.age,
    required this.imageUrl,
    required this.description,
    required this.breedName,
    required this.breedDescription,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      age: json['age'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      breedName: json['breedName'],
      breedDescription: json['breedDescription'],
    );
  }
}