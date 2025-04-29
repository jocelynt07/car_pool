import 'package:flutter/material.dart';
import 'carpool_registration.dart';  // Import the Carpool Registration screen

class CarpoolMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carpool Main Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Carpool App!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Carpool Registration page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CarpoolRegistrationPage()),
                );
              },
              child: Text('Register a Carpool'),
            ),
          ],
        ),
      ),
    );
  }
}
