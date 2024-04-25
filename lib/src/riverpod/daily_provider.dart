import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/model/daily.dart';
import 'package:habitpunk/src/riverpod/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:habitpunk/src/storage/secureStorage.dart';
import 'package:habitpunk/src/config/config.dart';

final dailyProvider = StateNotifierProvider<DailyNotifier, List<Daily>>(
    (ref) => DailyNotifier(ref));

class DailyNotifier extends StateNotifier<List<Daily>> {
  DailyNotifier(this.ref) : super([]);

  final StateNotifierProviderRef ref;

  Future<void> fetchDailies() async {
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
      final response = await http.get(
        Uri.parse(
            '${APIConfig.apiUrl}/api/dailies/uncompleted'), // Update this URL to your actual endpoint
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> dailiesJson = json.decode(response.body);
        state = dailiesJson.map((json) => Daily.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load dailies');
      }
    } catch (e) {
      print('Error fetching dailies: $e');
    }
  }

  Future<void> addDaily(Daily daily) async {
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
        Uri.parse('${APIConfig.apiUrl}/api/dailies'),
        headers: headers,
        body: json.encode(daily.toJson()),
      );

      if (response.statusCode == 201) {
        fetchDailies(); // Reload the list after adding
      } else {
        print('Server responded with status code: ${response.statusCode}');
        print('Server response body: ${response.body}');
        throw Exception('Failed to add daily');
      }
    } catch (e) {
      print('Error adding daily: $e');
    }
  }

  Future<void> checkOffDaily(String dailyId, bool completed) async {
    final secureStorage = SecureStorage();
    final token = await secureStorage.readSecureData('jwt');

    if (token == null) {
      throw Exception('No token found');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = json.encode({
      'completed': completed,
    });

    try {
      final response = await http.post(
        Uri.parse('${APIConfig.apiUrl}/api/dailies/$dailyId/perform'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        fetchDailies(); // Reload the list after performing the action
        ref.read(userProvider.notifier).loadUser();
      } else {
        print('Failed to check off daily: ${response.body}');
        throw Exception('Failed to check off daily');
      }
    } catch (e) {
      print('Error checking off daily: $e');
      throw e;
    }
  }
}