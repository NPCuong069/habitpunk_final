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
}
