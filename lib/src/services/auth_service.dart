import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<void> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      // Navigate or handle user data
    } catch (e) {
      print(e.toString());
      // Handle errors
    }
  }

  // Register with email and password
  Future<void> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      // Navigate or handle user data
    } catch (e) {
      print(e.toString());
      // Handle errors
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
