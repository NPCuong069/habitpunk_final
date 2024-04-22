import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:habitpunk/src/model/user.dart';
import 'package:habitpunk/src/storage/secureStorage.dart';
final userProvider = FutureProvider<User>((ref) async {
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
    Uri.parse('http://10.0.2.2:3000/api/user/info'), // Update this URL to your actual endpoint
    headers: headers,
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return User.fromJson(data);  // Make sure your API returns a single user object
  } else {
    throw Exception('Failed to load user data');
  }
});