import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart'; // Твои константы

class AuthService {
  static Future<String?> login(String email, String password) async {
    final url = Uri.parse('${AppConstants.apiBaseUrl}/auth/login');
    final bodyData = {
      "email": email,
      "password": password,
    };

    print('[AuthService] POST $url');
    print('[AuthService] Body: ${json.encode(bodyData)}');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(bodyData),
    );

    print('[AuthService] Status code: ${response.statusCode}');
    print('[AuthService] Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];

      print('[AuthService] Token received: $token');

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        print('[AuthService] Token сохранён в SharedPreferences');
      } catch (e) {
        print('[AuthService] ❌ Ошибка при сохранении токена: $e');
      }

      return token;
    } else {
      print('[AuthService] Login failed');
      return null;
    }
  }
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      print('[AuthService] Retrieved token: $token');
      return token;
    } catch (e) {
      print('[AuthService] ❌ Ошибка при получении токена: $e');
      return null;
    }
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    final result = token != null;
    print('[AuthService] isLoggedIn: $result');
    return result;
  }
}
