import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/model/item.dart';
import 'package:http/http.dart' as http;
import 'package:habitpunk/src/storage/secureStorage.dart';
import 'package:habitpunk/src/config/config.dart';

final itemProvider =
    StateNotifierProvider<ItemNotifier, List<Item>>((ref) => ItemNotifier(ref));

class ItemNotifier extends StateNotifier<List<Item>> {
  final Ref ref;

  ItemNotifier(this.ref) : super([]);

  Future<void> fetchItems() async {
    final secureStorage = SecureStorage();
    final token = await secureStorage.readSecureData('jwt');
    if (token == null) {
      throw Exception('No token found');
    }
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(Uri.parse('${APIConfig.apiUrl}/api/items'),
        headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      state = data.map((itemJson) => Item.fromJson(itemJson)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<bool> buyItem(int itemId) async {
    final secureStorage = SecureStorage();
    final token = await secureStorage.readSecureData('jwt');
    if (token == null) {
      throw Exception('No token found');
    }
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.post(
      Uri.parse('${APIConfig.apiUrl}/api/items/$itemId/purchase'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      fetchItems(); // Refresh the item list after purchase
      return true;
    } else {
      print('Failed to purchase item: ${response.body}');
      return false;
    }
  }
}
