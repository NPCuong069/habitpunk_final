import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/config/config.dart';
import 'package:habitpunk/src/storage/SecureStorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final partyQuestProvider = Provider<PartyQuestService>((ref) {
  return PartyQuestService();
});

class PartyQuestService {
  Future<bool> addPartyQuest(String partyId, int questId) async {
    final secureStorage = SecureStorage();
    final token = await secureStorage.readSecureData('jwt');
    if (token == null) {
      throw Exception('No token found');
    }
    var url = Uri.parse('${APIConfig.apiUrl}/api/partyQuest');
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Make sure to replace 'YOUR_TOKEN' with actual token handling logic
        },
        body: jsonEncode({
          'partyId': partyId,
          'questId': questId,
        }),
      );

      if (response.statusCode == 201) {
        return true; // Quest added successfully
      } else {
        // Handle different statuses or log an error
        print('Failed to add quest: ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle network error, etc.
      print('Error adding quest: $e');
      return false;
    }
  }
}
