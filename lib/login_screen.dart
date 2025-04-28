import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'carpool_main_page.dart';  // The main page after login
import 'registration_screen.dart';  // Registration page
import 'retrieve_password_screen.dart';  // Forgot password page

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Function to handle user login
  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please fill in both fields');
      return;
    }

    final user = await DatabaseHelper.instance.getUser(email);
    if (user != null && user['password'] == password) {
      _showMessage('Login Successful!');

      // Navigate to the main screen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CarpoolMainPage()),  // Navigate to the CarpoolMainPage
      );
    } else {
      _showMessage('Invalid Credentials');
    }
  }

  // Function to display a snack bar with a message
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(onPressed: _login, child: Text('Login')),

            // Links to navigate to Registration and Forgot Password pages
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()), // Navigate to Registration page
                );
              },
              child: Text("Don't have an account? Sign up"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RetrievePasswordScreen()), // Navigate to Forgot Password page
                );
              },
              child: Text("Forgot Password?"),
            ),
          ],
        ),
      ),
    );
  }
}
