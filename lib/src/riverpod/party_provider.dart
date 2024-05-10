import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/model/party.dart'; // Make sure you have a Party model
import 'package:http/http.dart' as http;
import 'package:habitpunk/src/storage/secureStorage.dart';
import 'package:habitpunk/src/config/config.dart';

final partyProvider =
    StateNotifierProvider<PartyNotifier, List<Party>>(// Corrected Provider
        (ref) => PartyNotifier(ref));

class PartyNotifier extends StateNotifier<List<Party>> {
  PartyNotifier(this.ref) : super([]);

  final StateNotifierProviderRef ref;

  Future<void> leaveParty() async {
    final secureStorage = SecureStorage();
    final token = await secureStorage.readSecureData('jwt');
    if (token == null) {
      throw Exception('No token found');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http.post(
        Uri.parse('${APIConfig.apiUrl}/api/user/leave-party'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        fetchParties(); // Update local party list after leaving the party
      } else {
        print('Failed to leave party: ${response.body}');
        throw Exception('Failed to leave party');
      }
    } catch (e) {
      print('Error leaving party: $e');
      throw e;
    }
  }

  Future<void> createParty(String partyName, String leaderId) async {
    final secureStorage = SecureStorage();
    final token = await secureStorage.readSecureData('jwt');
    if (token == null) {
      throw Exception('No token found');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http.post(
        Uri.parse('${APIConfig.apiUrl}/api/party/create'),
        headers: headers,
        body: jsonEncode({'name': partyName, 'leaderId': leaderId}),
      );

      if (response.statusCode == 201) {
        fetchParties(); // Fetch list of parties to update the state
      } else {
        print('Failed to create party: ${response.body}');
      }
    } catch (e) {
      print('Error creating party: $e');
      throw e;
    }
  }

  Future<void> fetchParties() async {
    final secureStorage = SecureStorage();
    final token = await secureStorage.readSecureData('jwt');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http.get(
        Uri.parse('${APIConfig.apiUrl}/api/party/details'),
        headers: headers,
      );
      print("Raw JSON data: ${response.body}");
      if (response.statusCode == 200) {
        // Decode response and expect a single party object
        Map<String, dynamic> data = json.decode(response.body);
        // Create a Party object and update the state with a list containing this single party
        Party party = Party.fromJson(data);
        state = [party];
      } else {  
        print(
            'Failed to fetch parties: ${response.statusCode} ${response.body}');
        state = [];
      }
    } catch (e) {
      print('Error fetching parties: $e');
      state = [];
    }
  }
}
