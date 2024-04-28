import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/storage/secureStorage.dart';

final tokenProvider = FutureProvider<String>((ref) async {
  final secureStorage = SecureStorage();
  final token = await secureStorage.readSecureData('jwt');
  
  if (token == null) {
    throw Exception('No token found');
  }
  
  return token;
});