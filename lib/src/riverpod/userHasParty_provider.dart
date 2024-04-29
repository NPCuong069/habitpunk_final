import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/riverpod/user_provider.dart';


final userPartyProvider = StateProvider<bool>((ref) {
  // Initial state can be set based on user data fetched from somewhere
  final user = ref.watch(userProvider);
  return user?.partyId != null;
});