import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/model/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:habitpunk/src/config/config.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, User?>((ref) => AuthNotifier());

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null);

  // Function to login and update the user state
  Future<void> login(String token) async {
    try {
      final response = await http.post(
        Uri.parse('${APIConfig.apiUrl}/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'token': token}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Received data: $data'); // Add this line to log the response data
        state =
            User.fromJson(data); // Ensure this matches the structure of 'data'
      } else {
        throw Exception('Failed to login, status code: ${response.statusCode}');
      }
    } catch (e) {
      print(
          'Login error: $e'); // This will log more detailed information about the error
      throw Exception('Failed to login: $e');
    }
  }

  // Function to log out the user
  void logout() {
    state = null;
  }
}
