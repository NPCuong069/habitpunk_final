import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/model/habit.dart';
import 'package:habitpunk/src/riverpod/token_provider.dart';
import 'package:habitpunk/src/riverpod/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:habitpunk/src/storage/secureStorage.dart';
import 'package:habitpunk/src/config/config.dart';

final habitProvider = StateNotifierProvider<HabitNotifier, List<Habit>>(
    (ref) => HabitNotifier(ref));

class HabitNotifier extends StateNotifier<List<Habit>> {
  final Ref ref;

  HabitNotifier(this.ref) : super([]);

  Future<void> fetchHabits() async {
    final secureStorage = SecureStorage();
    final token = await secureStorage.readSecureData('jwt');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('${APIConfig.apiUrl}/api/habits'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> habitsJson = json.decode(response.body);
      state = habitsJson.map((json) => Habit.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load habits');
    }
  }

  Future<void> addHabit(Habit habit) async {
    // Retrieve the stored token
    final secureStorage = SecureStorage();
    final token = await secureStorage.readSecureData('jwt');

    // Check if the token is null
    if (token == null) {
      throw Exception('No token found');
    }

    // Setup the authorization header
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(
        Uri.parse('${APIConfig.apiUrl}/api/habits'),
        headers: headers,
        body: json.encode(habit.toJson()),
      );

      if (response.statusCode == 201) {
        fetchHabits(); // Reload the list after adding
      } else {
        print('Server responded with status code: ${response.statusCode}');
        print('Server response body: ${response.body}');
        throw Exception('Failed to add daily');
      }
    } catch (e) {
      print('Error adding daily: $e');
    }
  }

  Future<void> performAction(String habitId, String action) async {
    final token = await ref.read(tokenProvider.future);
    try {
      final response = await http.post(
        Uri.parse('${APIConfig.apiUrl}/api/habits/$habitId/perform'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'action': action}),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to perform habit action: ${response.statusCode} ${response.body}');
      }

      fetchHabits(); // Refresh the habits list
    } catch (e) {
      print('Error performing action: $e');
      throw Exception('Failed to perform habit action');
    }
  }
}
