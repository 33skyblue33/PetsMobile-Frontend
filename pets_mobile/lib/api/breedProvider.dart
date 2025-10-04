import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'apiConfig.dart';
import 'models/breed.dart';

class BreedProvider with ChangeNotifier {
  List<Breed> _breeds = [];
  bool _isLoading = true;
  String? _error;

  List<Breed> get breeds => _breeds;
  bool get isLoading => _isLoading;
  String? get error => _error;

  BreedProvider() {
    fetchBreeds();
  }

  Future<void> fetchBreeds() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/Breeds');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        _breeds = jsonList.map((json) => Breed.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load breeds. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}