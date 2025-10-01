import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class User {
  final int id;
  final String name;
  final String surname;
  final int age;
  final String email;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.age,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json, String accessToken) {
    String userRole = "User"; 

    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      
      const String roleClaim = 'role';
      
      final dynamic roleValue = decodedToken[roleClaim];
      
      if (roleValue is List) {
        userRole = roleValue.isNotEmpty ? roleValue.first : "User";
      } else if (roleValue is String) {
        userRole = roleValue;
      }

    } catch (e) {
      print("Error decoding token: $e");
    }

    return User(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      age: json['age'],
      email: json['email'],
      role: userRole,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'age': age,
      'email': email,
    };
  }
}