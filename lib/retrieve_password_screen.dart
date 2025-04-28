import 'package:flutter/material.dart';
import 'database_helper.dart';

class RetrievePasswordScreen extends StatefulWidget {
  @override
  _RetrievePasswordScreenState createState() => _RetrievePasswordScreenState();
}

class _RetrievePasswordScreenState extends State<RetrievePasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController securityAnswerController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Function to handle password retrieval and reset
  void _verifyAnswerAndResetPassword() async {
    String email = emailController.text.trim();
    String answer = securityAnswerController.text.trim();
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    final user = await DatabaseHelper.instance.getUser(email);

    if (user == null) {
      _showMessage("User not found!");
      return;
    }

    if (user['security_answer'].toString() != answer) {
      _showMessage("Incorrect answer. Try again!");
      return;
    }

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showMessage("Please enter your new password!");
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage("Passwords do not match!");
      return;
    }

    await DatabaseHelper.instance.updateUserPassword(email, newPassword);
    _showMessage("Password updated successfully!");
    Navigator.pop(context);
  }

  // Function to display a message
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Retrieve Password")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: securityAnswerController, decoration: InputDecoration(labelText: 'Security Answer')),
            TextField(controller: newPasswordController, decoration: InputDecoration(labelText: 'New Password'), obscureText: true),
            TextField(controller: confirmPasswordController, decoration: InputDecoration(labelText: 'Confirm Password'), obscureText: true),
            ElevatedButton(onPressed: _verifyAnswerAndResetPassword, child: Text('Reset Password')),
          ],
        ),
      ),
    );
  }
}
