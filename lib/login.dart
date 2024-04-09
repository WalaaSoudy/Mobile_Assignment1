import 'package:flutter/material.dart';



import 'package:flutter_application_5/DbHelper.dart';
import 'package:flutter_application_5/profile.dart';

import 'package:flutter_application_5/signup.dart'; // Import the signup screen file

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late DbHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DbHelper();
  }

  void _login() {
    String studentID = _studentIdController.text.trim();
    String password = _passwordController.text.trim();

    BuildContext context = this.context;

    _dbHelper.getUser(studentID, password).then((user) {
      if (user != null) {
        // Login successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(user: user)),
        );
      } else {
        // Login failed
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Failed'),
            content: Text('Invalid student ID or password.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _studentIdController,
              decoration: InputDecoration(labelText: 'Student ID'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigate to the signup screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()), // Navigate to the signup screen
                );
              },
              child: Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
