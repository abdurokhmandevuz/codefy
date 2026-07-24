import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiService {
  static const String baseUrl = 'https://api.codefy.uz/api/v1';

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
  }

  // Token Management
  Future<String?> _getToken() async {
    final session = Supabase.instance.client.auth.currentSession;
    return session?.accessToken;
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

  Future<bool> updateUserProfile(String firstName, String lastName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/profile/update/'),
      headers: await _getAuthHeaders(),
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
      }),
    );
    
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {
            'full_name': '$firstName $lastName'.trim(),
          }
        )
      );
    } catch (e) {
      // Ignore if supabase update fails
    }
    
    return response.statusCode == 200;
  }

  Future<int?> decreaseHeart() async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/decrease-heart/'),
      headers: await _getAuthHeaders(),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['hearts'] as int?;
    }
    return null;
  }

  Future<Map<String, dynamic>?> refillHearts() async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/refill-hearts/'),
      headers: await _getAuthHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
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

  Future<Map<String, dynamic>?> completeLesson(int lessonId, {dynamic answer}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/lesson/$lessonId/complete/'),
      headers: await _getAuthHeaders(),
      body: jsonEncode({
        'answer': answer,
      }),
    );
    try {
      if (response.body.isNotEmpty) {
        return jsonDecode(response.body) as Map<String, dynamic>?;
      }
    } catch (_) {}
    return null;
  }

  Future<List<dynamic>?> getPracticeCards() async {
    final response = await http.get(
      Uri.parse('$baseUrl/practice/'),
      headers: await _getAuthHeaders(),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    return null;
  }

  Future<bool> completePracticeTask(int taskId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/practice/task/$taskId/complete/'),
      headers: await _getAuthHeaders(),
    );
    return response.statusCode == 200;
  }

  Future<List<dynamic>?> getLeaderboard() async {
    final response = await http.get(
      Uri.parse('$baseUrl/leaderboard/'),
      headers: await _getAuthHeaders(),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    return null;
  }
}
