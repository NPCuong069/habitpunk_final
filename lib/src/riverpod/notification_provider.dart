import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/config/config.dart';
import 'package:habitpunk/src/model/notification.dart';
import 'package:habitpunk/src/storage/SecureStorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final notificationProvider = Provider((ref) => NotificationService());

class NotificationService {
  final String apiUrl =
      '${APIConfig.apiUrl}/api/notifications'; // Change this URL to your actual API endpoint

  Future<List<NotificationModel>> fetchNotificationsByDaily(
      String dailyId) async {
    final secureStorage = SecureStorage();
    final token = await secureStorage.readSecureData('jwt');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/daily/$dailyId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Make sure your token is valid
      },
    );

    if (response.statusCode == 200) {
      // Assuming that the API returns 200 for a successful GET
      List<dynamic> notificationJsonList = json.decode(response.body);
      return notificationJsonList
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } else if (response.statusCode == 404) {
      throw Exception('Notifications not found for daily ID: $dailyId');
    } else {
      throw Exception(
          'Failed to fetch notifications. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteNotification(int? notificationId) async {
    final secureStorage = SecureStorage();
    final token = await secureStorage.readSecureData('jwt');

    if (token == null) {
      throw Exception('No token found');
    }

    var response = await http.delete(
      Uri.parse('$apiUrl/$notificationId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Notification deleted successfully');
    }
      else if (response.statusCode == 204) {
      print('Notification deleted successfully');
    } 
     else if (response.statusCode == 404) {
      print('Notification not found');
      throw Exception('Notification not found for ID: $notificationId');
    } else {
      throw Exception(
          'Failed to delete notification. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    try {
      final secureStorage = SecureStorage();
      final token = await secureStorage.readSecureData('jwt');

      if (token == null) {
        throw Exception('No token found');
      }
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add your auth token if needed
        },
        body: jsonEncode(notification.toJson()),
      );
      if (response.statusCode == 201) {
        print('Notification created successfully');
      } else {
        print(
            'Failed to create notification. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
