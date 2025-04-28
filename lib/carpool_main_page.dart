import 'package:flutter/material.dart';

class CarpoolMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carpool Main Page'),
      ),
      body: Center(
        child: Text('Welcome to Carpool App!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
