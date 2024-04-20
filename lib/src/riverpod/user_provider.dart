import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:habitpunk/src/model/user.dart';

final userProvider = FutureProvider<User>((ref) async {
  final response = await http.get(Uri.parse('https://5ff514c0941eaf0017f3676e.mockapi.io/User?username=Amina.Dooley9')); //NOTE: May replace with a reference link variables later

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return User.fromJson(data[0]); // Assuming the data is an array with one object
  } else {
    throw Exception('Failed to load user');
  }
});
