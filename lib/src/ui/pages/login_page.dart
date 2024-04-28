import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habitpunk/src/services/notification_service.dart';
import 'package:habitpunk/src/storage/secureStorage.dart';
import 'package:habitpunk/src/ui/pages/habits_page.dart';
import 'package:habitpunk/src/riverpod/auth_state.dart'; // Make sure this path is correct

final GoogleSignIn _googleSignIn = GoogleSignIn();
SecureStorage secureStorage = SecureStorage();

Future<void> _handleGoogleSignIn(BuildContext context, WidgetRef ref) async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        String? token = await userCredential.user?.getIdToken();
        if (token != null) {
          await secureStorage.writeSecureData(
              'jwt', token); // Save the token securely
          ref
              .read(authProvider.notifier)
              .login(token); // Use ref to interact with the provider
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
      }
    }
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to sign in with Google: ${e.message}')),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends ConsumerStatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (userCredential.user != null) {
          String? token = await userCredential.user?.getIdToken();
          if (token != null) {
            await secureStorage.writeSecureData(
                'jwt', token); // Save the token securely
            ref.read(authProvider.notifier).login(token); // Correctly use ref
            String? deviceToken = await NotificationService().getDeviceToken();
            if (deviceToken != null) {
              await secureStorage.writeSecureData('deviceToken',
                  deviceToken); // Optionally send this to your backend
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to login: ${e.message}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) =>
                value!.isEmpty ? 'Please enter your email' : null,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) =>
                value!.isEmpty ? 'Please enter your password' : null,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: _submit,
              child: Text('Login'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () => _handleGoogleSignIn(context, ref),
              child: Text('Sign in with Google'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
            child: Text("Don't have an account? Sign up"),
          ),
        ],
      ),
    );
  }
}
