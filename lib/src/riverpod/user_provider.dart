import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:habitpunk/src/storage/secureStorage.dart';
import 'package:habitpunk/src/config/config.dart';
import 'dart:convert';

final userProvider =
    StateNotifierProvider<UserNotifier, User?>((ref) => UserNotifier(ref));

class UserNotifier extends StateNotifier<User?> {
  UserNotifier(StateNotifierProviderRef<UserNotifier, User?> ref)
      : super(null) {
    loadUser();
  }

  Future<void> loadUser() async {
    final secureStorage = SecureStorage();
    final token = await secureStorage.readSecureData('jwt');
    if (token == null) {
      state = null;
      throw Exception('No token found');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('${APIConfig.apiUrl}/api/user/info'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      state = User.fromJson(data);
    } else {
      state = null;
      throw Exception('Failed to load user data');
    }
  }

  Future<void> updateEquipment(String category, int itemId) async {
    final secureStorage = SecureStorage();
    final token = await secureStorage.readSecureData('jwt');
    if (token == null) {
      throw Exception('Token not found');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      'itemType': category, // Ensure these keys match what your API expects
      'itemId': itemId,
    });

    try {
      final response = await http.post(
        Uri.parse('${APIConfig.apiUrl}/api/user/equip'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Equipment updated successfully');
        loadUser(); // Reload user to reflect the changes
      } else {
        // Log the status code and response body for debugging
        print('Failed to update equipment: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update equipment');
      }
    } catch (e) {
      print('Error updating equipment: $e');
      throw Exception('Failed to update equipment');
    }
  }
}
