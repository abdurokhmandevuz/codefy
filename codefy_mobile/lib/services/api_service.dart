import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://api.codefy.uz/api/v1';

  // Auth Methods
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access']);
      await prefs.setString('refresh_token', data['refresh']);
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'error': jsonDecode(response.body)};
    }
  }

  Future<Map<String, dynamic>> register(String username, String password, String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password, 'email': email}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access']);
      await prefs.setString('refresh_token', data['refresh']);
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'error': jsonDecode(response.body)};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  // Token Management
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // API Requests
  Future<Map<String, dynamic>?> getUserProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/profile/'),
      headers: await _getAuthHeaders(),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    return null;
  }

  Future<List<dynamic>?> getCourses() async {
    final response = await http.get(
      Uri.parse('$baseUrl/courses/'),
      headers: await _getAuthHeaders(),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    return null;
  }

  Future<Map<String, dynamic>?> getLessonDetail(int lessonId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/lesson/$lessonId/'),
      headers: await _getAuthHeaders(),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    return null;
  }

  Future<bool> completeLesson(int lessonId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/lesson/$lessonId/complete/'),
      headers: await _getAuthHeaders(),
    );
    return response.statusCode == 200;
  }
}
