import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/config/config.dart';
import 'package:habitpunk/src/storage/SecureStorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final invitationProvider =
    StateNotifierProvider<InvitationNotifier, List<dynamic>>(
  (ref) => InvitationNotifier(ref),
);

class InvitationNotifier extends StateNotifier<List<dynamic>> {
  final Ref ref;

  InvitationNotifier(this.ref) : super([]);

  Future<void> fetchInvitations() async {
    var url = Uri.parse('${APIConfig.apiUrl}/api/invitations');
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${await _getToken()}',
    });

    if (response.statusCode == 200) {
      List<dynamic> data =
          jsonDecode(response.body); // Assuming response.body is a JSON string
      // If data items are already decoded to Maps, no need to decode them again.
      state =
          data.map((item) => item).toList(); // Removed json.decode from here
    } else {
      throw Exception('Failed to load invitations: ${response.body}');
    }
  }

  Future<bool> createInvitation(String username) async {
    var url = Uri.parse('${APIConfig.apiUrl}/api/invitations');
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
        body: jsonEncode({'username': username}));

    return response.statusCode == 201;
  }

  Future<bool> acceptInvitation(int invitationId) async {
    var url =
        Uri.parse('${APIConfig.apiUrl}/api/invitations/accept/$invitationId');
    var response = await http.put(url, headers: {
      'Authorization': 'Bearer ${await _getToken()}',
    });

    return response.statusCode == 200;
  }

  Future<bool> declineInvitation(int invitationId) async {
    var url =
        Uri.parse('${APIConfig.apiUrl}/api/invitations/decline/$invitationId');
    var response = await http.put(url, headers: {
      'Authorization': 'Bearer ${await _getToken()}',
    });

    return response.statusCode == 200;
  }

  Future<String> _getToken() async {
    final secureStorage = SecureStorage();
    final token = await secureStorage.readSecureData('jwt');

    if (token == null) {
      throw Exception('No token found');
    }
    return token;
  }
}
