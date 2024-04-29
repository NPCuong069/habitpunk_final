import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/config/config.dart';
import 'package:habitpunk/src/model/quest.dart';
import 'package:http/http.dart' as http;
final questProvider = StateNotifierProvider<QuestNotifier, List<Quest>>((ref) {
  return QuestNotifier();
});

class QuestNotifier extends StateNotifier<List<Quest>> {
  QuestNotifier() : super([]);

  Future<void> fetchQuests() async {
    try {
      final response = await http.get(Uri.parse('${APIConfig.apiUrl}/api/quests'));
      if (response.statusCode == 200) {
        List<dynamic> questJson = jsonDecode(response.body);
        state = questJson.map((json) => Quest.fromJson(json)).toList();
      } else {
        // Handle error or set an empty list
        state = [];
      }
    } catch (e) {
      // Handle exception by setting an empty list or managing state appropriately
      state = [];
    }
  }
}