import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:habitpunk/src/storage/secureStorage.dart';
import 'package:habitpunk/src/config/config.dart';
import 'dart:convert';


final userEquipmentProvider = FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
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
    'itemType': params['itemType'],
    'itemId': params['itemId'],
  });

  final response = await http.post(
    Uri.parse('${APIConfig.apiUrl}/api/user/${params['firebase_uid']}/equip'),
    headers: headers,
    body: body,
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update equipment');
  }

  // If needed, you can update the user state here or force refresh the user data
});
