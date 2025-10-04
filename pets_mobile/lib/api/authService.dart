import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'apiConfig.dart';
import 'models/user.dart';

class AuthService with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final String _baseUrl = ApiConfig.baseUrl;

  User? _user;
  String? _accessToken;
  String? _refreshTokenCookie;
  bool _isLoading = true;

  User? get user => _user;
  String? get accessToken => _accessToken;
  bool get isLoggedIn => _accessToken != null;
  bool get isLoading => _isLoading;

  AuthService() {
    tryAutoLogin();
  }

  Future<void> tryAutoLogin() async {
    _refreshTokenCookie = await _storage.read(key: 'refreshTokenCookie');

    if (_refreshTokenCookie != null) {
      await refresh();
    }

    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/Auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      _accessToken = responseData['accessToken'];
      _user = User.fromJson(responseData['user'], _accessToken!);
      await _handleSetCookie(response.headers);
      await _persistAuthData();
      notifyListeners();
    } else {
      throw Exception('Failed to log in. Status: ${response.statusCode}');
    }
  }

  Future<void> register(String name, String surname, int age, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/Users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'surname': surname,
        'age': age,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register. Status: ${response.statusCode}');
    }
  }

  Future<void> refresh() async {
    if (_refreshTokenCookie == null) return;
    final response = await http.put(
      Uri.parse('$_baseUrl/Auth/refresh'),
      headers: {'Cookie': _refreshTokenCookie!},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      _accessToken = responseData['accessToken'];
      _user = User.fromJson(responseData['user'], _accessToken!);
      await _handleSetCookie(response.headers);
      await _persistAuthData();
    } else {
      await logout();
    }
    notifyListeners();
  }

  Future<void> logout() async {
    if (_refreshTokenCookie != null) {
      try {
        await http.post(
          Uri.parse('$_baseUrl/Auth/logout'),
          headers: {'Cookie': _refreshTokenCookie!},
        );
      } catch (e) {
        
      }
    }
    _user = null;
    _accessToken = null;
    _refreshTokenCookie = null;
    await _storage.deleteAll();
    notifyListeners();
  }
  
  Future<void> _handleSetCookie(Map<String, String> headers) async {
    final cookies = headers['set-cookie'];
    if (cookies != null) {
      _refreshTokenCookie = cookies.split(';').firstWhere((c) => c.startsWith('refreshToken='));
      await _storage.write(key: 'refreshTokenCookie', value: _refreshTokenCookie);
    }
  }

  Future<void> _persistAuthData() async {
    if (_accessToken != null && _user != null) {
      await _storage.write(key: 'accessToken', value: _accessToken);
      await _storage.write(key: 'user', value: jsonEncode(_user!.toJson()));
    }
  }
}