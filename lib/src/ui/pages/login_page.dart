import 'package:flutter/material.dart';
import 'package:habitpunk/main.dart';


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

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  // Hardcoded dummy account credentials for testing
  final String _dummyEmail = '1';
  final String _dummyPassword = '1';

  // Text Editing Controllers to retrieve the current value of TextFormFields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submit() {
    // Checking if form is valid before performing login
    if (_formKey.currentState!.validate()) {
      // Checking against dummy credentials
      if (_emailController.text == _dummyEmail && _passwordController.text == _dummyPassword) {
        // If the input matches the dummy account, proceed to the HabitsPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        // If input doesn't match, display an error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect email or password')),
        );
      }
    }
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
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
            controller: _emailController, // Use the controller
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
          ),
          TextFormField(
            controller: _passwordController, // Use the controller
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: _submit,
              child: Text('Login'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
            child: Text('Don\'t have an account? Sign up'),
          ),
        ],
      ),
    );
  }
}
