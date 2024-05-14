import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/config/config.dart';
import 'package:habitpunk/src/model/subscriptionOption.dart';
import 'package:habitpunk/src/riverpod/user_provider.dart';
import 'package:habitpunk/src/storage/SecureStorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, List<SubscriptionOption>>((ref) {
  return SubscriptionNotifier(ref);
});

class SubscriptionNotifier extends StateNotifier<List<SubscriptionOption>> {
  SubscriptionNotifier(this.ref) : super([]);

  final Ref ref;

Future<bool> addSubscription(int months) async {
      final secureStorage = SecureStorage();
    final token = await secureStorage.readSecureData('jwt');
    if (token == null) {
      throw Exception('No token found');
    }
  try {
    var response = await http.post(
      Uri.parse('${APIConfig.apiUrl}/api/subscription'),
      headers: {"Content-Type": "application/json",  'Authorization':
              'Bearer $token', },
      body: jsonEncode({"months": months}),
    );
    if (response.statusCode == 200) {
       ref.read(userProvider.notifier).loadUser();
      return true;
    } else {
      print('Failed to add subscription: ${response.statusCode} ${response.body}');
      return false;
    }
  } catch (e) {
    print('Exception when calling subscription: $e');
    return false;
  }
}
}
