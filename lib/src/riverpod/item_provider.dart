import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/model/item.dart';
import 'package:http/http.dart' as http;
import 'package:habitpunk/src/storage/secureStorage.dart';
import 'package:habitpunk/src/config/config.dart';

final itemProvider = FutureProvider<List<Item>>((ref) async {
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

  // Make a GET request to your actual API endpoint
  final response = await http.get(
    Uri.parse(
        '${APIConfig.apiUrl}/api/items'), // Update this URL to your actual endpoint
    headers: headers,
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Item> items =
        data.map((itemJson) => Item.fromJson(itemJson)).toList();
    return items;
  } else {
    throw Exception('Failed to load user data');
  }
});
